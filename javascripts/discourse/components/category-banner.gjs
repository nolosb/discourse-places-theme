import DiscoveryBanner from "./discovery-banner.gjs";

// The category's name and description, with its logo as the banner image.
// Background images aren't used (see page.scss).
const CategoryBanner = <template>
  <DiscoveryBanner
    class="--category"
    @darkImage={{@category.uploaded_logo_dark}}
    @description={{@category.descriptionText}}
    @lightImage={{@category.uploaded_logo}}
    @title={{@category.displayName}}
  />
</template>;

export default CategoryBanner;
