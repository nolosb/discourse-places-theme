import Component from "@glimmer/component";
import { apiInitializer } from "discourse/lib/api";
import CategoryBanner from "../components/category-banner.gjs";
import TopMenuBanner from "../components/top-menu-banner.gjs";

// Above the navigation, inside the discovery layout, so the banners take the
// list's column and the sidebar panels keep their place beside them.
// Category pages show the category banner, the other discovery pages the top
// menu banner from top_menu_banners, in place of core's welcome banner, which
// is hidden everywhere. Tag pages show neither.
export default apiInitializer((api) => {
  const banners = settings.top_menu_banners;

  api.registerValueTransformer("welcome-banner-display-for-route", () => false);

  api.renderInOutlet(
    "discovery-list-controls-above",
    class extends Component {
      static shouldRender(outletArgs) {
        return !outletArgs.tag;
      }

      <template>
        {{#if @outletArgs.category}}
          <CategoryBanner @category={{@outletArgs.category}} />
        {{else}}
          <TopMenuBanner @banners={{banners}} />
        {{/if}}
      </template>
    }
  );
});
