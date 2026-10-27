import DLightDarkImg from "discourse/ui-kit/d-light-dark-img";
import dConcatClass from "discourse/ui-kit/helpers/d-concat-class";

// Title and description on a wash of the banner color, with an optional
// light/dark image whole at the end.
const DiscoveryBanner = <template>
  <section
    class={{dConcatClass "discovery-banner" (if @lightImage.url "--has-image")}}
    ...attributes
  >
    <div class="discovery-banner__text">
      <h1 class="discovery-banner__title">{{@title}}</h1>
      {{#if @description}}
        <p class="discovery-banner__description">{{@description}}</p>
      {{/if}}
    </div>
    {{#if @lightImage.url}}
      <div class="discovery-banner__image">
        <DLightDarkImg @darkImg={{@darkImage}} @lightImg={{@lightImage}} />
      </div>
    {{/if}}
  </section>
</template>;

export default DiscoveryBanner;
