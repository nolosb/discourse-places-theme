import { settings } from "virtual:theme";
import BlockHead from "discourse/blocks/builtin/block-head";
import { apiInitializer } from "discourse/lib/api";
import BlockPlace from "../blocks/block-place.gjs";
import BlockResources from "../blocks/block-resources.gjs";
import BlockTopics from "../blocks/block-topics.gjs";
import {
  categoryScope,
  defaultEntries,
  scopedEntries,
  withoutEmptyContainers,
} from "../lib/category-scoped-layout.js";

// The panels next to the topic lists and the categories page, top to bottom:
// places, resources, topics. Each block has the entries scoped to categories first and
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
              icon: "lightbulb",
              mobile: false,
              links: entry.links,
            },
            conditions: categoryScope(entry.categories),
          })),
          ...defaultEntries(settings.resources_panel).map((entry) => ({
            block: BlockResources,
            args: {
              title: "resources.title",
              icon: "lightbulb",
              mobile: false,
              links: entry.links,
            },
          })),
        ],
      },
      {
        block: BlockHead,
        id: "topics",
        children: [
          ...scopedEntries(settings.topics_panel).map((entry) => ({
            block: BlockTopics,
            args: {
              title: "topics.title",
              icon: "heart",
              mobile: false,
              count: 5,
              showCategory: true,
              order: entry.order,
              tag: entry.tag?.[0],
            },
            conditions: categoryScope(entry.categories),
          })),
          ...defaultEntries(settings.topics_panel).map((entry) => ({
            block: BlockTopics,
            args: {
              title: "topics.title",
              icon: "heart",
              mobile: false,
              count: 5,
              showCategory: true,
              order: entry.order,
              tag: entry.tag?.[0],
            },
          })),
        ],
      },
    ])
  );
});
