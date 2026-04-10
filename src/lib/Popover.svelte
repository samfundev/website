<script>
	const { children, trigger } = $props();
	const popoverId = $props.id();
	const anchorId = `--anchor-${popoverId}`;
</script>

<div class="group">
	{@render trigger({
		style: `anchor-name: ${anchorId}`
	})}
	<div
		class="popover pointer-events-none fixed z-10 w-96 rounded-lg bg-gray-50 p-4 opacity-0 shadow-sm transition-opacity group-hover:opacity-100"
		id={popoverId}
		style={`position-anchor: ${anchorId}; position-area: right;`}
	>
		{@render children()}
	</div>
</div>

<style>
	.popover {
		margin: 0.25rem;

		position-try-fallbacks:
			flip-block,
			flip-inline,
			flip-block flip-inline;
	}
</style>
