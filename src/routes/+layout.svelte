<script module>
	import p from '$lib/p.svelte';
	export { p };
</script>

<script lang="ts">
	import './layout.css';
	import favicon from '$lib/assets/favicon.png';
	import { send, receive } from '$lib';
	import { page } from '$app/state';

	let { children } = $props();

	const pages = { Home: '/', Blog: '/blog', Projects: '/projects', Contact: '/contact' };
</script>

<svelte:head><link rel="icon" href={favicon} /></svelte:head>

<div class="h-full">
	<div class="gradient flex flex-col items-center space-y-5 p-5">
		<h1 class="name group flex gap-0 p-3 text-center text-6xl hover:gap-2">
			{#each ['sam', 'is', 'fun', 'and a', 'dev'] as word, i (word)}
				<div
					in:receive={{ key: word }}
					out:send={{ key: word }}
					class={[
						i % 2 == 1 &&
							`w-0 origin-left scale-x-0 text-nowrap transition-all duration-500 group-hover:w-(--length) group-hover:scale-x-100`
					]}
					style={`--length: ${word.length}ch`}
				>
					{word}
				</div>
			{/each}
		</h1>

		<nav class="flex w-full max-w-80 flex-wrap justify-between gap-1 text-lg">
			{#each Object.entries(pages) as [value, href], i (i)}
				<a class="relative px-1 py-1" {href}>
					{value}
					{#if href === '/' ? page.url.pathname === href : page.url.pathname.startsWith(href)}
						<div
							class="absolute top-0 -right-1 bottom-0 -left-1 rounded-2xl outline"
							in:receive={{ key: 'active' }}
							out:send={{ key: 'active' }}
						></div>
					{/if}
				</a>
			{/each}
		</nav>
	</div>
	<main class="relative mx-auto prose p-5">
		{#key page.route.id}
			<!-- <div
					in:receivetype={{ key: 'content', splitWord: false }}
					out:sendtype={{ key: 'content', splitWord: false }}
				>
					{@render children()}
				</div> -->
		{/key}
		{@render children()}
	</main>
</div>

<!-- <div class="wrapper" inert>
	<div class="background">
		{@html backgroundText().replaceAll(
			'samfundev',
			"<span style='color: #fff; -webkit-text-stroke-color: #000'>samfundev</span>"
		)}
	</div>
</div> -->

<!-- <canvas class="absolute top-0 -z-1 h-full w-full bg-amber-50" bind:this={canvas}></canvas> -->

<style>
	:global(html, body) {
		height: 100%;
		/* font-family: 'Ostrich Sans Heavy'; */
	}

	.name > span {
		margin-inline: 15px;
	}

	.gradient {
		background: linear-gradient(45deg, #2e85b7 0%, #03e47d 100%);
		color: white;
		font-weight: bold;
		-webkit-text-stroke: #333 2px;
		paint-order: stroke;
	}

	.wrapper {
		position: absolute;
		top: 0;
		left: 0;
		width: 100%;
		height: 100%;
		overflow: hidden;
	}

	.background {
		position: absolute;
		top: -50px;
		left: -50px;
		width: calc(100% + 100px);
		height: calc(100% + 100px);
		background: linear-gradient(45deg, #2e85b7 0%, #03e47d 100%);
		background-repeat: no-repeat;
		/* background-clip: text; */
		-webkit-text-stroke: 1px #fff;
		text-align: justify;
		color: transparent;
		z-index: -1;
		text-transform: uppercase;
		font-size: 5vw;
		line-height: 1.1;

		font-family: 'Ostrich Sans Heavy', sans-serif;
	}

	@font-face {
		font-family: 'Ostrich Sans Heavy';
		src: url('/OstrichSans-Heavy.otf') format('opentype');
	}

	/* main {
		backdrop-filter: blur(2px) brightness(0.5);
	} */
</style>
