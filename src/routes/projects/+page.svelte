<script lang="ts">
	import Card from '$lib/Card.svelte';

	const projects = [
		{
			title: 'Text-Field Calculator',
			href: 'https://samfundev.github.io/TextFieldCalculator/Calculator-v2.html',
			image: 'text-field-calculator.png',
			description:
				'A calculator that allows you to play with math by evaluating each line whenever you change it. Powered by Math.js and Monaco Editor.',
			category: 'Web'
		},
		{
			title: 'Tetris-Attack',
			href: 'https://files.samfun.dev/tetrisattack/',
			image: 'tetris-attack.png',
			description:
				'A recreation of the classic puzzle game Tetris Attack built in WebGL. Pretty proud of how I built out all the graphics and animations using only rectangles.',
			category: 'Web'
		},
		{
			title: 'Tweaks',
			href: 'https://samfundev.github.io/KTANE-Mods/tweaks',
			image:
				'https://images.steamusercontent.com/ugc/2444768537696491535/8B64931A5F6C99991A0F12714F1A484BDDFA9482/',
			description:
				"An extensive mod for Keep Talking and Nobody Explodes that adds a bunch of quality of life improvements to the game. It gained an essential feature that's allows a huge amount of mods to be installed while only loading the necessary ones.",
			category: 'C#'
		},
		{
			title: 'TP:KTANE',
			href: 'https://github.com/samfundev/KtaneTwitchPlays/',
			image:
				'https://github.com/samfundev/KtaneTwitchPlays/blob/master/Assets/PreviewImage/PreviewImage.png?raw=true',
			description:
				'A mod for Keep Talking and Nobody Explodes that allows the game to be played on Twitch by using chat commands. Initally created by ashbash1987 and later maintained by me, it has grown to be a pretty popular way to play the game.',
			category: 'C#'
		},
		{
			title: 'Skewed Slots',
			href: 'https://steamcommunity.com/sharedfiles/filedetails/?id=764289972',
			image:
				'https://images.steamusercontent.com/ugc/842646362417609934/52426203172DF15B3C49CFEF1D75EF4C2B732854/',
			description:
				'My first module for Keep Talking and Nobody Explodes, where each calculation depends on the previous one, making it more difficult to solve.',
			category: 'C#'
		},
		{
			title: 'The Gamepad',
			href: 'https://steamcommunity.com/sharedfiles/filedetails/?id=776105833',
			image:
				'https://images.steamusercontent.com/ugc/2444768537694213231/33A45795F787F1497DE0FEC9FA02F1A667C2D2FF/',
			description:
				'A module for Keep Talking and Nobody Explodes where you use the numbers displayed to find the correct cheat code. Which you enter on a video game controller.',
			category: 'C#'
		},
		{
			title: 'Broken Buttons',
			href: 'https://steamcommunity.com/sharedfiles/filedetails/?id=817404979',
			image:
				'https://images.steamusercontent.com/ugc/842646362417607453/A6E6487EA743899A829B83CEC8B7F5C7F351C807/',
			description:
				'A module for Keep Talking and Nobody Explodes where you have to follow a set of rules to find which button to press but that changes the text on the button. So previously inapplicable rules can become applicable.',
			category: 'C#'
		},
		{
			title: 'Cheap Checkout',
			href: 'https://steamcommunity.com/sharedfiles/filedetails/?id=844093428',
			image:
				'https://images.steamusercontent.com/ugc/887630175956180553/A3880FB68ABC86B835CD51D25BBA678CCFD41526/',
			description:
				'A module for Keep Talking and Nobody Explodes where you have to calculate the change to give a customer based on the items they are purchasing. Watch out for quirky sales depending on the day of the week and weight based items.',
			category: 'C#'
		},
		{
			title: 'Creation',
			href: 'https://steamcommunity.com/sharedfiles/filedetails/?id=907916539',
			image:
				'https://images.steamusercontent.com/ugc/172669362202047278/97A69B8FC306C28FF514B4584779D1ADD0D171BD/',
			description:
				'A module for Keep Talking and Nobody Explodes where you combine elements to create a new lifeform! Be careful as changes in weather can throw off your combinations.',
			category: 'C#'
		},
		{
			title: 'Minesweeper',
			href: 'https://steamcommunity.com/sharedfiles/filedetails/?id=945682169',
			image:
				'https://images.steamusercontent.com/ugc/868480740217612025/9E2944E29F14D25927DC9CD3F3C86AE12C6F6D1F/',
			description:
				"A module for Keep Talking and Nobody Explodes where you get to play the classic game of minesweeper! But you'll need to figure out where you can begin digging.",
			category: 'C#'
		},
		{
			title: 'Synchronization',
			href: 'https://steamcommunity.com/sharedfiles/filedetails/?id=1483210664',
			image:
				'https://images.steamusercontent.com/ugc/968724515912610310/486B3AB3F44C7E17F392597A72AACE682457282C/',
			description:
				"A module for Keep Talking and Nobody Explodes where it's become horribly desynchronized! Can you fix it? Sync all the lights up on the module and then sync the module to the bomb to solve this module.",
			category: 'C#'
		},
		{
			title: 'Encrypted Equations',
			href: 'https://steamcommunity.com/sharedfiles/filedetails/?id=1758398098',
			image:
				'https://images.steamusercontent.com/ugc/804369128316319061/B0EB3E69093861CE97F4596D422FE19419DCCDD5/',
			description:
				'A module for Keep Talking and Nobody Explodes where the equations have been encrypted! Decrypt the values, operators, parentheses, and more to solve the equation.',
			category: 'C#'
		},
		{
			title: 'Challenge Missions',
			href: 'https://bombs.samfun.dev/',
			image: 'challenge-missions.png',
			description:
				'A website for tracking leaderboards for KTANE Challenge Missions. View your stats compared to other players and see how you rank on the solver leaderboard.',
			category: 'Web'
		},

		{
			title: 'TGB Schedule',
			href: 'https://samfundev.github.io/TGB-Schedule/',
			image: 'tgb-schedule.png',
			description:
				'A schedule made for The Great Berate to allow you easily see when their next stream is in your local time zone. It also has a countdown to the next stream and upcoming streams.',
			category: 'Web'
		},
		{
			title: 'Logfile Analyzer',
			href: 'https://ktane.timwi.de/More/Logfile%20Analyzer.html',
			image: 'logfile-analyzer.png',
			description:
				'A tool for analyzing logfiles from Keep Talking and Nobody Explodes. It breaks down everything that happened during a bomb and how each module can be solved.',
			category: 'Web'
		},
		{
			title: 'Profile Editor',
			href: 'https://ktane.timwi.de/More/Profile%20Editor.html',
			image: 'profile-editor.png',
			description:
				"A tool for editing profiles in Keep Talking and Nobody Explodes. Useful to change what modules you're able to solve so that you can share your profile with other people.",
			category: 'Web'
		},

		// all my ktane manuals, KTANE-Bot, RepoLint,
		// Open source work
		// group together ktane stuff
		// sort by best projects or something instead of just chronologically
		// better icons for each project

		{
			title: 'Twire',
			href: 'https://github.com/twireapp/twire',
			image:
				'https://github.com/twireapp/Twire/raw/master/fastlane/metadata/android/en-US/images/phoneScreenshots/1_my_streams.png?raw=true',
			description:
				'An open source, ad-free Twitch browser and stream player for Android. It has a built in adblock, support for VODs with chat replay, custom emotes, picture in picture mode, and a highly customizable UI. ',
			category: 'Java'
		}
	];
</script>

<svelte:head>
	<title>Projects</title>
</svelte:head>

<h1>Projects</h1>

<p>I've worked on quite a few projects over the years. Here are some of them:</p>

{#each ['Web', 'C#', 'Java'] as category}
	<h2>{category}</h2>
	<div class="not-prose grid grid-cols-2 gap-2">
		{#each projects.filter((project) => project.category === category) as project}
			<Card {...project} />
		{/each}
	</div>
{/each}
