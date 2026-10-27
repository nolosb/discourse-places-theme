import Component from "@glimmer/component";
import { trustHTML } from "@ember/template";
import DiscoveryBanner from "./discovery-banner.gjs";

// The category's name, description and color, with its logo as the banner
// image. Background images aren't used (see page.scss).
export default class CategoryBanner extends Component {
  get style() {
    return trustHTML(`--discovery-banner-color: #${this.args.category.color}`);
  }

  <template>
    <DiscoveryBanner
      class="--category"
      style={{this.style}}
      @darkImage={{@category.uploaded_logo_dark}}
      @description={{@category.descriptionText}}
      @lightImage={{@category.uploaded_logo}}
      @title={{@category.displayName}}
    />
  </template>
}
