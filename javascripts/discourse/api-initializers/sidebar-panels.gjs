import { settings } from "virtual:theme";
import BlockHead from "discourse/blocks/builtin/block-head";
import { apiInitializer } from "discourse/lib/api";
import BlockPlace from "../blocks/block-place.gjs";
import BlockResources from "../blocks/block-resources.gjs";
import BlockUsers from "../blocks/block-users.gjs";
import {
  categoryScope,
  defaultEntries,
  scopedEntries,
  withoutEmptyContainers,
} from "../lib/category-scoped-layout.js";

// The panels next to the topic lists and the categories page, top to bottom:
// places, resources, users. Each block has the entries scoped to categories first and
// the unscoped entry last; BlockHead renders the first one that matches.
export default apiInitializer((api) => {
  api.renderBlocks(
    "sidebar-discovery",
    withoutEmptyContainers([
      {
        block: BlockHead,
        id: "place",
        children: [
          ...scopedEntries(settings.places_panel).map((entry) => ({
            block: BlockPlace,
            args: {
              title: "place.all_places",
              icon: "compass",
              mobile: false,
              showDescription: true,
              showTopicCounts: true,
              allPlacesUrl: entry.all_places_url,
            },
            conditions: categoryScope(entry.categories),
          })),
          ...defaultEntries(settings.places_panel).map((entry) => ({
            block: BlockPlace,
            args: {
              title: "place.all_places",
              icon: "compass",
              mobile: false,
              showDescription: true,
              showTopicCounts: true,
              allPlacesUrl: entry.all_places_url,
            },
          })),
        ],
      },
      {
        block: BlockHead,
        id: "resources",
        children: [
          ...scopedEntries(settings.resources_panel).map((entry) => ({
            block: BlockResources,
            args: {
              title: "resources.title",
              icon: "signs-post",
              mobile: false,
              links: entry.links,
            },
            conditions: categoryScope(entry.categories),
          })),
          ...defaultEntries(settings.resources_panel).map((entry) => ({
            block: BlockResources,
            args: {
              title: "resources.title",
              icon: "signs-post",
              mobile: false,
              links: entry.links,
            },
          })),
        ],
      },
      {
        block: BlockHead,
        id: "users",
        children: [
          ...scopedEntries(settings.users_panel).map((entry) => ({
            block: BlockUsers,
            args: usersArgs(entry),
            conditions: categoryScope(entry.categories),
          })),
          ...defaultEntries(settings.users_panel).map((entry) => ({
            block: BlockUsers,
            args: usersArgs(entry),
          })),
        ],
      },
    ])
  );
});

// The title and icon follow the order the list is ranked by
const USER_ICONS = {
  likes_received: "heart",
  likes_given: "hand-holding-heart",
  topic_count: "pen-to-square",
  post_count: "comments",
  topics_entered: "eye",
  posts_read: "book-open",
  days_visited: "calendar-check",
};

function usersArgs(entry) {
  return {
    title: `users.title.${entry.order}`,
    icon: USER_ICONS[entry.order],
    mobile: false,
    count: entry.count,
    order: entry.order,
    period: entry.period,
    groupId: entry.group?.[0],
  };
}
