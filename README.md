# Places

A playful theme that adds banners and a handy sidebar to topic lists.

These theme components install with it:

| Component | Adds |
| --- | --- |
| [Full width](https://github.com/discourse/discourse-full-width-component) | Full-width page and header layout |

## Banners

A banner sits above the navigation in the topic list's column, at one fixed height so the page doesn't jump between banners.

- **Top menu banner:** replaces core's welcome banner on the top menu pages. Each entry in `top_menu_banners` has a title, description, image and dark image. The entry without a page shows everywhere; an entry with a page picked replaces it on that page. Without an image, the banner on Latest, New, Hot and Categories shows a Fluent Emoji illustration (party popper, sparkles, fire, compass). No search field: the header search sits right above it.
- **Category banner:** on category pages, the category's name and description on the same wash as the top menu banner, with its logo at the banner's end. Without a logo, a category styled with an emoji shows that emoji large in its place, as a Twemoji SVG from jsDelivr, while the site uses the default emoji set. Category background images aren't shown.

## Sidebar panels

Next to the topic lists on wide screens, top to bottom:

- **Place:** the current top-level category with its subcategories, or every top-level category on global lists. `places_panel` sets where it shows and where its "All places" link goes.
- **Good to know:** a list of links. `resources_panel` holds the links.
- **Most loved:** the five most liked topics of the current place, or of the whole site on global lists. `topics_panel` sets the order and an optional tag.

Each setting takes entries scoped to categories (they apply on those categories and their subcategories) and one entry without categories for everywhere else; leaving out the unscoped entry hides that panel outside the scoped categories. Panels don't show on small screens.

## Layout

The search field in the header starts at the main column's edge, up to 24rem wide. The page widens by the panels' width while a panel renders. The top menu has no Categories tab, whatever the `top_menu` site setting lists; the `/categories` page still works. Topic lists have no Views column.

## Credits

Illustrations: [Fluent Emoji](https://github.com/microsoft/fluentui-emoji) by Microsoft (MIT)
