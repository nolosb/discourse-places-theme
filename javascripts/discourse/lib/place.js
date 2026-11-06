// The place of a category page is its top-level category: a subcategory page
// belongs to the parent's place. No category means a global list.
export function placeOf(category) {
  return category?.parentCategory ?? category ?? null;
}
