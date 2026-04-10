<script lang="ts">
	import Card from '$lib/Card.svelte';

	const posts = import.meta.glob('/src/routes/blog/**/*.md', { eager: true });
</script>

<svelte:head>
	<title>Blog</title>
</svelte:head>

<h1>Blog</h1>

<p>Here's some thoughts I've scraped together:</p>

<div class="grid grid-cols-2 gap-4">
	{#each Object.entries(posts) as [path, post]}
		<Card
			title={post.metadata.title}
			href={path.replace('/src/routes', '').replace('/+page.md', '')}
		/>
	{/each}
</div>
