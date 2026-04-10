/** @type {import('tailwindcss').Config} */
module.exports = {
	theme: {
		extend: {
			typography: {
				DEFAULT: {
					css: {
						'code::before': {
							content: 'none',
						},
						'code::after': {
							content: 'none',
						},
						'code': {
							padding: '0.2em 0.4em',
							borderRadius: '0.25rem',
							backgroundColor: 'rgba(0, 0, 0, 0.05)',
						},
					},
				},
			},
		},
	},
}