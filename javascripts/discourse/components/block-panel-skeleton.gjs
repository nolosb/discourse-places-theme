import Component from "@glimmer/component";
import DSkeleton from "discourse/ui-kit/d-skeleton";

// Loading placeholder for a panel body. The shape follows core's
// BlockSkeletonShape (variant, count, width, height) so it can move into a
// block's `data.skeleton` declaration later. `rows: "topic"` is a theme
// extension for composed rows that plain DSkeleton cannot express: a title
// line over a meta line, `count` times.
export default class BlockPanelSkeleton extends Component {
  get rows() {
    const count = this.args.shape?.count ?? 5;
    return Array.from({ length: count }, (_, index) => index);
  }

  <template>
    <div aria-hidden="true" class="block-panel-skeleton">
      {{#if (eq @shape.rows "topic")}}
        {{#each this.rows as |row|}}
          <div class="block-panel-skeleton__row --topic" data-row={{row}}>
            <div class="block-panel-skeleton__lines">
              <DSkeleton @variant="text" @width="90%" />
              <DSkeleton @variant="text" @width="40%" />
            </div>
          </div>
        {{/each}}
      {{else}}
        <DSkeleton
          @count={{@shape.count}}
          @height={{@shape.height}}
          @variant={{@shape.variant}}
          @width={{@shape.width}}
        />
      {{/if}}
    </div>
  </template>
}

function eq(a, b) {
  return a === b;
}
