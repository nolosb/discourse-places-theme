import Component from "@glimmer/component";
import { themePrefix } from "virtual:theme";
import { block } from "discourse/blocks";
import getURL from "discourse/lib/get-url";
import dIcon from "discourse/ui-kit/helpers/d-icon";
import { i18n } from "discourse-i18n";
import BlockPanel from "../components/block-panel.gjs";

function isExternal(url) {
  try {
    return (
      new URL(url, window.location.origin).origin !== window.location.origin
    );
  } catch {
    return false;
  }
}

function normalizeLink(link) {
  const url = link.url?.trim();
  if (!link.label?.trim() || !url) {
    return null;
  }
  const external = isExternal(url);
  return {
    label: link.label.trim(),
    description: link.description?.trim() || null,
    icon: link.icon?.trim() || null,
    url:
      /^[a-z][a-z\d+.-]*:/i.test(url) || url.startsWith("//")
        ? url
        : getURL(url.startsWith("/") ? url : `/${url}`),
    external,
  };
}

// The layout selects the resource links for the current category and passes
// them here. Link fields follow core's link-list block (label, url, icon,
// description) so the content transfers to it unchanged.
@block("theme:places:resources", {
  description: "A titled list of resource links",
  args: {
    title: { type: "string", required: true },
    icon: { type: "string" },
    mobile: { type: "boolean", default: false },
    links: { type: "array", default: [] },
  },
})
export default class BlockResources extends Component {
  get links() {
    return (this.args.links ?? []).map(normalizeLink).filter(Boolean);
  }

  <template>
    {{#if this.links.length}}
      <BlockPanel
        class="block-resources"
        @icon={{@icon}}
        @mobile={{@mobile}}
        @title={{i18n (themePrefix @title)}}
      >
        <:content>
          <ul class="block-resources__list">
            {{#each this.links as |link|}}
              <li class="block-resources__item">
                <a
                  class="block-resources__link"
                  href={{link.url}}
                  rel={{if link.external "noopener noreferrer"}}
                  target={{if link.external "_blank"}}
                >
                  {{#if link.icon}}
                    <span class="block-resources__icon">{{dIcon
                        link.icon
                      }}</span>
                  {{/if}}
                  <span class="block-resources__text">
                    <span class="block-resources__label">{{link.label}}</span>
                    {{#if link.description}}
                      <span
                        class="block-resources__description"
                      >{{link.description}}</span>
                    {{/if}}
                  </span>
                </a>
              </li>
            {{/each}}
          </ul>
        </:content>
      </BlockPanel>
    {{/if}}
  </template>
}
