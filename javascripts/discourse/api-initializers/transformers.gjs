import { apiInitializer } from "discourse/lib/api";

export default apiInitializer((api) => {
  // No Categories tab: the sidebar and the Discovery Sidebar lead to the
  // categories instead. The /categories page itself still works.
  api.registerValueTransformer("navigation-items", ({ value }) =>
    value.filter((item) => item.name !== "categories")
  );

  // Fewer numbers on topic lists: replies and activity stay
  api.registerValueTransformer("topic-list-columns", ({ value: columns }) => {
    columns.delete("views");
    return columns;
  });
});
