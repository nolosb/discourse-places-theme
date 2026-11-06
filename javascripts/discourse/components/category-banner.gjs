import Component from "@glimmer/component";
import { service } from "@ember/service";
import { replacements } from "pretty-text/emoji/data";
import dConcatClass from "discourse/ui-kit/helpers/d-concat-class";
import DiscoveryBanner from "./discovery-banner.gjs";

// Core's emoji images are 72px PNGs, too small for the banner; the default
// set's SVGs scale sharply
const TWEMOJI_SVG_URL =
  "https://cdn.jsdelivr.net/gh/jdecked/twemoji@16.0.1/assets/svg";

let unicodeByName;

function twemojiUrl(name) {
  // several characters can share a name; the first is the emoji itself, the
  // later ones text symbols core converts to it
  if (!unicodeByName) {
    unicodeByName = new Map();
    for (const [unicode, emoji] of Object.entries(replacements)) {
      if (!unicodeByName.has(emoji)) {
        unicodeByName.set(emoji, unicode);
      }
    }
  }

  const unicode = unicodeByName.get(name);
  if (!unicode) {
    return null;
  }

  // Twemoji file names drop the variation selector, except in sequences
  // joined with a zero-width joiner
  let codepoints = [...unicode].map((char) => char.codePointAt(0));
  if (!codepoints.includes(0x200d)) {
    codepoints = codepoints.filter((codepoint) => codepoint !== 0xfe0f);
  }

  const fileName = codepoints.map((codepoint) => codepoint.toString(16));
  return `${TWEMOJI_SVG_URL}/${fileName.join("-")}.svg`;
}

// The category's name and description, with its logo as the banner image, or
// its emoji, large, while it has no logo. Background images aren't used (see
// page.scss).
export default class CategoryBanner extends Component {
  @service siteSettings;

  get emojiImage() {
    const { style_type, emoji } = this.args.category;
    if (
      style_type !== "emoji" ||
      !emoji ||
      this.siteSettings.emoji_set !== "twitter"
    ) {
      return null;
    }

    const url = twemojiUrl(emoji);
    return url ? { url } : null;
  }

  get lightImage() {
    return this.args.category.uploaded_logo ?? this.emojiImage;
  }

  get showsEmoji() {
    return !this.args.category.uploaded_logo && !!this.emojiImage;
  }

  <template>
    <DiscoveryBanner
      class={{dConcatClass "--category" (if this.showsEmoji "--emoji")}}
      @darkImage={{@category.uploaded_logo_dark}}
      @description={{@category.descriptionText}}
      @lightImage={{this.lightImage}}
      @title={{@category.displayName}}
    />
  </template>
}
