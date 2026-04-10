<script lang="ts">
	import { sendtype, receivetype } from '$lib';
	import { increment, reset } from "$lib/test.svelte";

	const { children } = $props();

	let id = increment("h1");
</script>

<h1
	data-testing={id}
	in:receivetype={{ key: id, splitWord: false }}
	out:sendtype={{ key: id, splitWord: false }}
>
	{@render children()}
</h1>
