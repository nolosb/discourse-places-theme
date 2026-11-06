import Component from "@glimmer/component";
import { service } from "@ember/service";
import { themePrefix } from "virtual:theme";
import { block } from "discourse/blocks";
import { number } from "discourse/lib/formatter";
import getURL from "discourse/lib/get-url";
import { i18n } from "discourse-i18n";
import BlockPanel from "../components/block-panel.gjs";
import CategoryMark from "../components/category-mark.gjs";
import { placeOf } from "../lib/place.js";

// The current place: the top-level category of the page and all its
// subcategories, the current one highlighted. On global lists (Latest, Top,
// tags) the panel lists every top-level category instead, under @title. All
// content comes from the route and the site's category list, so there is no
// data setting and no loading state; the args are display choices. The
// places setting decides on which categories the layout renders it and where
// its "All places" link goes.
@block("theme:places:place", {
  description: "The current top-level category and its subcategories",
  args: {
    title: { type: "string", required: true },
    icon: { type: "string" },
    mobile: { type: "boolean", default: false },
    showDescription: { type: "boolean", default: true },
    showTopicCounts: { type: "boolean", default: true },
    allPlacesUrl: {
      type: "string",
      default: "/",
      enum: ["/", "/latest", "/categories"],
    },
  },
})
export default class BlockPlace extends Component {
  @service discovery;
  @service site;

  isCurrent = (category) => category.id === this.category?.id;

  get allPlacesUrl() {
    return getURL(this.args.allPlacesUrl ?? "/");
  }

  get category() {
    return this.discovery.category;
  }

  get place() {
    return placeOf(this.category);
  }

  get subcategories() {
    return this.visible(this.place?.subcategories ?? []);
  }

  get topLevelCategories() {
    return this.visible(
      this.site.categories.filter((c) => !c.parent_category_id)
    );
  }

  visible(categories) {
    return categories.filter((c) => !c.isHidden && !c.isUncategorizedCategory);
  }

  <template>
    {{#if this.place}}
      <BlockPanel class="block-place" @mobile={{@mobile}}>
        <:header>
          <div
            class="block-place__intro
              {{if (this.isCurrent this.place) '--current'}}"
          >
            <a
              aria-current={{if (this.isCurrent this.place) "page"}}
              class="block-place__head"
              href={{this.place.url}}
            >
              <CategoryMark @category={{this.place}} />
              <span class="block-place__name">{{this.place.displayName}}</span>
            </a>
            {{#if @showDescription}}
              {{#if this.place.descriptionText}}
                <p
                  class="block-place__description"
                >{{this.place.descriptionText}}</p>
              {{/if}}
            {{/if}}
          </div>
        </:header>
        <:content>
          {{#if this.subcategories.length}}
            <ul class="block-place__list">
              {{#each this.subcategories as |subcategory|}}
                <li
                  class="block-place__item
                    {{if (this.isCurrent subcategory) '--current'}}"
                >
                  <a
                    aria-current={{if (this.isCurrent subcategory) "page"}}
                    class="block-place__link"
                    href={{subcategory.url}}
                  >
                    <CategoryMark @category={{subcategory}} />
                    <span
                      class="block-place__name"
                    >{{subcategory.displayName}}</span>
                    {{#if @showTopicCounts}}
                      <span class="block-place__count">
                        {{i18n
                          (themePrefix "place.topic_count")
                          count=subcategory.topic_count
                          formatted_number=(number subcategory.topic_count)
                        }}
                      </span>
                    {{/if}}
                  </a>
                </li>
              {{/each}}
            </ul>
          {{/if}}
        </:content>
        <:footer>
          <a class="block-panel__link" href={{this.allPlacesUrl}}>
            {{i18n (themePrefix "place.all_places_link")}}
          </a>
        </:footer>
      </BlockPanel>
    {{else if this.topLevelCategories.length}}
      <BlockPanel
        class="block-place --global"
        @icon={{@icon}}
        @mobile={{@mobile}}
        @title={{i18n (themePrefix @title)}}
      >
        <:content>
          <ul class="block-place__list">
            {{#each this.topLevelCategories as |category|}}
              <li class="block-place__item">
                <a class="block-place__link" href={{category.url}}>
                  <CategoryMark @category={{category}} />
                  <span
                    class="block-place__name"
                  >{{category.displayName}}</span>
                  {{#if @showTopicCounts}}
                    <span class="block-place__count">
                      {{i18n
                        (themePrefix "place.topic_count")
                        count=category.totalTopicCount
                        formatted_number=(number category.totalTopicCount)
                      }}
                    </span>
                  {{/if}}
                </a>
              </li>
            {{/each}}
          </ul>
        </:content>
      </BlockPanel>
    {{/if}}
  </template>
}
