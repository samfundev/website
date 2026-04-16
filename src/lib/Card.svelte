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
	class="group flex flex-col items-center overflow-hidden rounded-lg border no-underline transition-colors hover:bg-gray-200"
>
	{#if image}
		<div class="relative flex min-w-full grow items-center justify-center overflow-hidden">
			{#if imageModule}
				<enhanced:img
					src={imageModule?.default}
					alt={title}
					class="aspect-square w-full object-cover"
				/>
			{:else}
				<img src={image} alt={title} class="aspect-square w-full object-cover" />
			{/if}
			<span
				class="bg-opacity-75 absolute inset-0 flex items-center justify-center bg-gray-100/90 p-4 text-center text-black opacity-0 transition-opacity group-hover:opacity-100"
			>
				{description}
			</span>
		</div>
	{/if}
	<b class="p-4 text-xl">{title}</b>
</a>
