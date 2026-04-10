import { SvelteMap } from 'svelte/reactivity';

let counts = $state(new SvelteMap());

export function increment(type: string) {
	if (!counts.has(type)) {
		counts.set(type, 0);
	}
	const count = counts.get(type);
	// console.log('incrementing', count);
	counts.set(type, count + 1);
	return `${type}-${count + 1}`;
}

export function reset() {
	// console.log('resetting');
	counts.clear();
}

import.meta.hot?.on('vite:afterUpdate', () => {
	// console.log('hot update, resetting');
	reset();
});
