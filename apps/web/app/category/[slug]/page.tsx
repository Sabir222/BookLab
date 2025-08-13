import { CategoryPage } from "./CategoryPage";

export default async function Page({ params }: { params: Promise<{ slug: string }> }) {
  return <CategoryPage params={params} />;
}