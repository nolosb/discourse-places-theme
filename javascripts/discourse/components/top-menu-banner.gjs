import Component from "@glimmer/component";
import { service } from "@ember/service";
import DiscoveryBanner from "./discovery-banner.gjs";

// Fluent Emoji illustrations for banners on these pages without an image
const DEFAULT_IMAGES = {
  latest: "party_popper",
  new: "sparkles",
  hot: "fire",
};

// The banner for the current top menu page: the entry scoped to it, else the
// entry without a page, else nothing.
export default class TopMenuBanner extends Component {
  @service router;

  get page() {
    return this.router.currentRouteName?.replace(/^discovery\./, "");
  }

  get banner() {
    return (
      this.args.banners.find((banner) => banner.page === this.page) ??
      this.args.banners.find((banner) => !banner.page)
    );
  }

  get lightImage() {
    const url =
      this.banner.image ?? settings.theme_uploads[DEFAULT_IMAGES[this.page]];
    return url ? { url } : null;
  }

  get darkImage() {
    return this.banner.image_dark ? { url: this.banner.image_dark } : null;
  }

  <template>
    {{#if this.banner}}
      <DiscoveryBanner
        class="--top-menu"
        @darkImage={{this.darkImage}}
        @description={{this.banner.description}}
        @lightImage={{this.lightImage}}
        @title={{this.banner.title}}
      />
    {{/if}}
  </template>
}
