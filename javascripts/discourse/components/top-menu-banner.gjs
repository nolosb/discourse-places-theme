import Component from "@glimmer/component";
import { service } from "@ember/service";
import DiscoveryBanner from "./discovery-banner.gjs";

// The banner for the current top menu page: the entry scoped to it, else the
// entry without a page, else nothing.
export default class TopMenuBanner extends Component {
  @service router;

  get banner() {
    const page = this.router.currentRouteName?.replace(/^discovery\./, "");

    return (
      this.args.banners.find((banner) => banner.page === page) ??
      this.args.banners.find((banner) => !banner.page)
    );
  }

  get lightImage() {
    return this.banner.image ? { url: this.banner.image } : null;
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
