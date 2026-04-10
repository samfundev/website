import { crossfade, fade } from 'svelte/transition';
import { quintOut, sineInOut } from 'svelte/easing';
import BezierEasing from '$lib/easing';

export const [send, receive] = crossfade({
	duration: (d) => Math.sqrt(d * 500),
	easing: BezierEasing(0.33, 1.2, 0.64, 1),
	fallback(node, params) {
		const style = getComputedStyle(node);
		const transform = style.transform === 'none' ? '' : style.transform;

		return {
			duration: 600,
			easing: quintOut,
			css: (t) => `
				transform: ${transform} scale(${t});
				opacity: ${t};
			`
		};
	}
});

function truncate(html: string, maxLength: number, splitWord: boolean = true): string {
	const parser = new DOMParser();
	const doc = parser.parseFromString(html, 'text/html');

	let currentLength = 0;

	function traverse(node: Node): boolean {
		if (currentLength >= maxLength) {
			// Hide this node
			if (node.nodeType === Node.TEXT_NODE) {
				node.textContent = '';
			} else if (node.nodeType === Node.ELEMENT_NODE) {
				(node as HTMLElement).style.visibility = 'hidden';
			}
			return false;
		}

		if (node.nodeType === Node.TEXT_NODE) {
			const text = node.textContent || '';
			if (currentLength + text.length > maxLength) {
				let index = maxLength - currentLength;
				if (!splitWord) {
					// Move back to the last space to avoid splitting words
					const lastSpaceIndex = text.lastIndexOf(' ', index);
					if (lastSpaceIndex > -1) {
						index = lastSpaceIndex;
					}
				}

				// Hide the excess part
				const visiblePart = text.slice(0, index);
				const hiddenPart = text.slice(index);

				const parent = node.parentNode;
				const span = doc.createElement('span');
				span.textContent = hiddenPart;
				span.style.visibility = 'hidden';

				node.textContent = visiblePart;
				parent?.insertBefore(span, node.nextSibling);

				currentLength = maxLength;
				return false;
			}
			currentLength += text.length;
			return true;
		}

		if (node.nodeType === Node.ELEMENT_NODE) {
			const childNodes = Array.from(node.childNodes);
			for (const child of childNodes) {
				traverse(child);
			}
		}

		return true;
	}

	traverse(doc.body);
	return doc.body.innerHTML;
}

const remap = (x, a, b, c, d) => ((x - a) * (d - c)) / (b - a) + c;

function crosstype({ fallback, ...defaults }) {
	/** @type {Map<any, Element>} */
	const to_receive = new Map();
	/** @type {Map<any, Element>} */
	const to_send = new Map();

	/**
	 * @param {Element} from_node
	 * @param {Element} node
	 * @param {CrossfadeParams} params
	 * @returns {TransitionConfig}
	 */
	function crosstype(from_node, from_rect, node, params) {
		const {
			delay = 0,
			duration = 400, ///** @param {number} d */ (d) => Math.sqrt(d) * 30,
			easing = sineInOut
		} = Object.assign(Object.assign({}, defaults), params);
		// from_node.inert = false;

		const from = from_rect;
		const to = node.getBoundingClientRect();
		const dx = from.left - to.left;
		const dy = from.top - to.top;
		const dw = from.width / to.width;
		const dh = from.height / to.height;
		const d = Math.sqrt(dx * dx + dy * dy);
		const style = getComputedStyle(node);
		const transform = style.transform === 'none' ? '' : style.transform;
		const opacity = +style.opacity;
		const oldText = from_node.textContent;
		const newText = node.textContent;
		const oldHTML = from_node.innerHTML;
		const newHTML = node.innerHTML;

		// console.log('crosstype', oldText, newText);

		// from_node.remove();

		// from_node.inert = true;

		from_node.style.visibility = 'hidden';

		return {
			delay,
			duration: typeof duration === 'function' ? duration(d) : duration,
			easing,
			tick: (t) => {
				const midpoint = oldText.length / (oldText.length + newText.length);
				const out = t < midpoint;
				const f = out ? remap(t, 0, midpoint, 1, 0) : remap(t, midpoint, 1, 0, 1);
				const html = out ? oldHTML : newHTML;
				const text = out ? oldText : newText;
				const i = Math.trunc(text.length * f);
				// console.log(truncate(html, i, params.splitWord), i);

				node.style.visibility = i === 0 ? 'hidden' : 'visible';
				if (i !== 0) node.innerHTML = truncate(html, i, params.splitWord);

				node.style.height = `${from.height + (to.height - from.height) * t}px`;
				// node.style.top = `${from.top + (to.top - from.top) * t}px`;

				// const current = node.getBoundingClientRect();
				// const dx = from.left - current.left;
				// const dy = from.top - current.top;
				// console.log('tick', t, dx, dy);
				// node.style.transform = `translate(${dx}px, ${dy}px)`
				node.style.transform = `translate(${dx * (1 - t)}px, ${dy * (1 - t)}px)`;
			}
			// css: (t, u) => `
			// 	   opacity: ${t * opacity};
			// 	   transform-origin: top left;
			// 	   transform: ${transform} translate(${u * dx}px,${u * dy}px) scale(${t + (1 - t) * dw}, ${
			// 				t + (1 - t) * dh
			// 			});
			//    `
		};
	}

	/**
	 * @param {Map<any, Element>} items
	 * @param {Map<any, Element>} counterparts
	 * @param {boolean} intro
	 * @returns {(node: any, params: CrossfadeParams & { key: any; }) => () => TransitionConfig}
	 */
	function transition(items, counterparts, intro) {
		// @ts-expect-error TODO improve typings (are the public types wrong?)
		return (node, params, options) => {
			items.set(params.key, [node, node.getBoundingClientRect()]);
			return () => {
				if (counterparts.has(params.key)) {
					if (options.direction === 'out') return;
					const [other_node, other_rect] = counterparts.get(params.key);
					console.log('crossfading', params, options, other_rect);
					counterparts.delete(params.key);
					return crosstype(/** @type {Element} */ other_node, other_rect, node, params);
				}
				// if the node is disappearing altogether
				// (i.e. wasn't claimed by the other list)
				// then we need to supply an outro
				items.delete(params.key);
				params.duration = 400;
				return fallback && fallback(node, params, intro);
			};
		};
	}
	return [() => null, () => null];
	// return [transition(to_send, to_receive, false), transition(to_receive, to_send, true)];
}

function collapse(node, { delay = 0, duration = 300, easing = sineInOut }) {
	const style = getComputedStyle(node);
	const height = parseFloat(style.height);
	const padding_top = parseFloat(style.paddingTop);
	const padding_bottom = parseFloat(style.paddingBottom);
	const margin_top = parseFloat(style.marginTop);
	const margin_bottom = parseFloat(style.marginBottom);
	const border_top = parseFloat(style.borderTopWidth);
	const border_bottom = parseFloat(style.borderBottomWidth);

	return {
		delay,
		duration,
		easing,
		css: (t) =>
			`overflow: hidden;` +
			`height: ${t * height}px;` +
			`padding-top: ${t * padding_top}px;` +
			`padding-bottom: ${t * padding_bottom}px;` +
			`margin-top: ${t * margin_top}px;` +
			`margin-bottom: ${t * margin_bottom}px;` +
			`border-top-width: ${t * border_top}px;` +
			`border-bottom-width: ${t * border_bottom}px;`
	};
}

const [sendtype, receivetype] = crosstype({ fallback: collapse });

export { sendtype, receivetype, collapse };
