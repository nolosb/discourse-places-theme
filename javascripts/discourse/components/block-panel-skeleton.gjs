import Component from "@glimmer/component";
import DSkeleton from "discourse/ui-kit/d-skeleton";

// Loading placeholder for a panel body. The shape follows core's
// BlockSkeletonShape (variant, count, width, height) so it can move into a
// block's `data.skeleton` declaration later. `rows` is a theme extension for
// composed rows that plain DSkeleton cannot express, `count` times:
//   { rows: "user" }   avatar circle + name line + score
export default class BlockPanelSkeleton extends Component {
  get rows() {
    const count = this.args.shape?.count ?? 5;
    return Array.from({ length: count }, (_, index) => index);
  }

  <template>
    <div aria-hidden="true" class="block-panel-skeleton">
      {{#if (eq @shape.rows "user")}}
        {{#each this.rows as |row|}}
          <div class="block-panel-skeleton__row --user" data-row={{row}}>
            <DSkeleton @size="1.5rem" @variant="circle" />
            <DSkeleton @variant="text" @width="55%" />
            <DSkeleton @variant="text" @width="2.5rem" />
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
