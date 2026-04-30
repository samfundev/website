<script lang="ts">
	import { sendtype, receivetype, collapse } from '$lib';
	import { increment, reset } from '$lib/test.svelte';
	import { fade } from 'svelte/transition';
	import Popover from './Popover.svelte';
	import type { Picture } from '@sveltejs/enhanced-img';

	let id = increment('card');

	interface Props {
		title: string;
		image?: string;
		href: string;
		description?: string;
	}

	const { title, image, href, description }: Props = $props();

	const imageModules: Record<string, { default: Picture }> = import.meta.glob(
		'/src/lib/assets/*.png',
		{
			eager: true,
			query: { enhanced: true }
		}
	);
	const imageModule = $derived(image ? imageModules[`/src/lib/assets/${image}`] : null);
</script>

<!-- <Popover>
	{#snippet trigger(props)}
		<a
			{href}
			class="group flex flex-col items-center overflow-hidden rounded-lg border no-underline transition-colors hover:bg-gray-200"
			{...props}
		>
		{#if image}
				<div class="grow overflow-hidden">
					<img
						src={image}
						alt={title}
						class="h-full object-contain transition-transform group-hover:scale-105"
					/>
				</div>
			{/if}
			<b class="p-4 text-xl">{title}</b>
		</a>
	{/snippet}
	{description}
</Popover> -->

<a
	{href}
	class="group flex flex-col overflow-hidden rounded-lg border no-underline transition-colors hover:bg-gray-200 sm:flex-row"
>
	{#if image}
		<div class="h-80 min-w-80">
			{#if imageModule}
				<enhanced:img src={imageModule?.default} alt={title} class="h-full w-full object-cover" />
			{:else}
				<img src={image} alt={title} class="h-full w-full object-cover" />
			{/if}
		</div>
	{/if}
	<div class="space-y-2 p-4">
		<b class="block text-xl">{title}</b>
		<div class="leading-snug">
			{description}
		</div>
	</div>
</a>
