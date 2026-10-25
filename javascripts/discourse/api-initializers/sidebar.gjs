import { apiInitializer } from "discourse/lib/api";

export default apiInitializer((api) => {
  // The left sidebar starts closed on every page load; the header toggle
  // still opens it. Core has no transformer for the initial state.
  api.modifyClass(
    "controller:application",
    (Superclass) =>
      class extends Superclass {
        calculateShowSidebar() {
          return false;
        }
      }
  );
});
