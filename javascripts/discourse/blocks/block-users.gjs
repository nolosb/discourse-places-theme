import Component from "@glimmer/component";
import { tracked } from "@glimmer/tracking";
import { service } from "@ember/service";
import { themePrefix } from "virtual:theme";
import { block } from "discourse/blocks";
import { ajax } from "discourse/lib/ajax";
import { bind } from "discourse/lib/decorators";
import getURL from "discourse/lib/get-url";
import { prioritizeNameInUx } from "discourse/lib/settings";
import DUserAvatar from "discourse/ui-kit/d-user-avatar";
import DUserLink from "discourse/ui-kit/d-user-link";
import dNumber from "discourse/ui-kit/helpers/d-number";
import { i18n } from "discourse-i18n";
import BlockPanel from "../components/block-panel.gjs";

export const USER_ORDERS = [
  "likes_received",
  "likes_given",
  "topic_count",
  "post_count",
  "topics_entered",
  "posts_read",
  "days_visited",
];

// Top users of the user directory (the /u page), ranked by one of its
// columns over a period, optionally within a group. The layout selects the
// entry for the current category; the directory itself counts site-wide.
// Core adds the logged-in viewer on top of the first page when they're not
// in it; only the ranked rows are kept. The panel disappears when the
// directory is off (403), the group is unknown (400) or isn't visible to the
// viewer.
@block("theme:places:users", {
  description: "Top users of the user directory",
  args: {
    title: { type: "string", required: true },
    icon: { type: "string" },
    mobile: { type: "boolean", default: false },
    order: { type: "string", default: "likes_received", enum: USER_ORDERS },
    period: {
      type: "string",
      default: "all",
      enum: ["all", "yearly", "quarterly", "monthly", "weekly", "daily"],
    },
    groupId: { type: "number", integer: true, min: 1 },
    count: { type: "number", required: true },
  },
})
export default class BlockUsers extends Component {
  @service site;

  @tracked unavailableQuery;
  @tracked retryCount = 0;

  displayName = (user) =>
    prioritizeNameInUx(user.name) ? user.name : user.username;

  get groupName() {
    const { groupId } = this.args;
    if (!groupId) {
      return null;
    }
    return this.site.groups?.find((group) => group.id === groupId)?.name;
  }

  get query() {
    const { order, period } = this.args;
    const query = { order, period };
    if (this.groupName) {
      query.group = this.groupName;
    }
    return query;
  }

  get queryKey() {
    return new URLSearchParams(this.query).toString();
  }

  get unavailable() {
    return (
      (this.args.groupId && !this.groupName) ||
      this.unavailableQuery === this.queryKey
    );
  }

  get viewAllUrl() {
    return getURL(`/u?${this.queryKey}`);
  }

  get skeleton() {
    return { rows: "user", count: this.args.count };
  }

  get context() {
    return {
      query: this.query,
      queryKey: this.queryKey,
      count: this.args.count,
      retryCount: this.retryCount,
    };
  }

  @bind
  retry() {
    this.retryCount++;
  }

  @bind
  async fetchUsers({ query, queryKey, count }) {
    try {
      const result = await ajax("/directory_items.json", {
        data: { ...query, limit: count },
      });
      const items = result?.directory_items ?? [];
      // the viewer core puts first has no rank: drop everything past the
      // page, then the extra item at the top
      const ranked = items.length > count ? items.slice(1) : items;
      return ranked.length
        ? ranked.slice(0, count).map((item, index) => ({
            rank: index + 1,
            user: item.user,
            score: item[query.order],
            hasScore: item[query.order] != null,
          }))
        : null;
    } catch (error) {
      if ([400, 403, 404].includes(error.jqXHR?.status)) {
        if (!this.isDestroying) {
          this.unavailableQuery = queryKey;
        }
        return null;
      }
      throw error;
    }
  }

  <template>
    {{#unless this.unavailable}}
      <BlockPanel
        class="block-users"
        @asyncData={{this.fetchUsers}}
        @context={{this.context}}
        @icon={{@icon}}
        @mobile={{@mobile}}
        @onRetry={{this.retry}}
        @skeleton={{this.skeleton}}
        @title={{i18n (themePrefix @title)}}
      >
        <:content as |rows|>
          <ol class="block-users__list">
            {{#each rows as |row|}}
              <li class="block-users__row">
                <span class="block-users__rank">{{row.rank}}</span>
                <DUserAvatar @size="small" @user={{row.user}} />
                <DUserLink class="block-users__name" @user={{row.user}}>
                  {{this.displayName row.user}}
                </DUserLink>
                {{#if row.hasScore}}
                  <span class="block-users__score">{{dNumber row.score}}</span>
                {{/if}}
              </li>
            {{/each}}
          </ol>
        </:content>
        <:empty>
          <p class="block-users__empty">
            {{i18n (themePrefix "users.empty")}}
          </p>
        </:empty>
        <:footer>
          <a class="block-panel__link" href={{this.viewAllUrl}}>
            {{i18n (themePrefix "users.view_all")}}
          </a>
        </:footer>
      </BlockPanel>
    {{/unless}}
  </template>
}
