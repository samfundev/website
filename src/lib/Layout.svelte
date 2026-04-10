<script module>
	import { beforeNavigate } from '$app/navigation';
	import p from '$lib/p.svelte';
	import h1 from '$lib/h1.svelte';
	import { reset } from './test.svelte';
	import H1 from '$lib/h1.svelte';
	export { p, h1 };
</script>

<script lang="ts">
	const { children, title } = $props();

	beforeNavigate(() => reset());
</script>

<svelte:head>
	<title>{title}</title>
</svelte:head>

<H1>{title}</H1>

{@render children()}
