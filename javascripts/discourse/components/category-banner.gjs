import Component from "@glimmer/component";
import { service } from "@ember/service";
import { trustHTML } from "@ember/template";
import DiscoveryBanner from "./discovery-banner.gjs";

// The category's name, description and color, with its logo as the banner
// image. Background images aren't used (see page.scss).
export default class CategoryBanner extends Component {
  @service siteSettings;

  get style() {
    return trustHTML(`--discovery-banner-color: #${this.args.category.color}`);
  }

  // Fluent versions of the seeded categories' emojis, while they have no
  // logo. Site Feedback's id isn't sent to the client, so it goes by its
  // seeded slug.
  get defaultImage() {
    const { id, slug } = this.args.category;
    let name;

    if (id === this.siteSettings.general_category_id) {
      name = "blue_book";
    } else if (id === this.siteSettings.staff_category_id) {
      name = "shield";
    } else if (slug === "site-feedback") {
      name = "thought_balloon";
    }

    const url = settings.theme_uploads[name];
    return url ? { url } : null;
  }

  get lightImage() {
    return this.args.category.uploaded_logo ?? this.defaultImage;
  }

  <template>
    <DiscoveryBanner
      class="--category"
      style={{this.style}}
      @darkImage={{@category.uploaded_logo_dark}}
      @description={{@category.descriptionText}}
      @lightImage={{this.lightImage}}
      @title={{@category.displayName}}
    />
  </template>
}
