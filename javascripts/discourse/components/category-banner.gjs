import Component from "@glimmer/component";
import { trustHTML } from "@ember/template";
import CategoryLogo from "discourse/components/category-logo";
import DiscoveryBanner from "./discovery-banner.gjs";

// The category's name, description, logo and color. Its background image
// shows in the banner instead of behind the page (see page.scss).
export default class CategoryBanner extends Component {
  get style() {
    return trustHTML(`--discovery-banner-color: #${this.args.category.color}`);
  }

  get hasLogo() {
    return (
      this.args.category.uploaded_logo || this.args.category.uploaded_logo_dark
    );
  }

  <template>
    <DiscoveryBanner
      class="--category"
      style={{this.style}}
      @darkImage={{@category.uploaded_background_dark}}
      @description={{@category.descriptionText}}
      @lightImage={{@category.uploaded_background}}
      @title={{@category.displayName}}
    >
      {{#if this.hasLogo}}
        <CategoryLogo class="discovery-banner__logo" @category={{@category}} />
      {{/if}}
    </DiscoveryBanner>
  </template>
}
