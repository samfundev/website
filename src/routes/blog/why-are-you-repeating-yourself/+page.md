---
title: Why Are You Repeating Yourself?
---

I've noticed a pattern of hidden inefficiency that now that I know about it, I feel like I'm seeing it everywhere I look. Basically, you want to create `X` but that requires interfacing with `Y`. And that wouldn't be an issue, but there's multiple versions of `Y`, so you have to create <code>X<sub>y1</sub>, X<sub>y2</sub>, ..., X<sub>yn</sub></code>. As an example: you want to make an elevator. Should be pretty simple, maybe you have new safety innovation to bring to elevators. But instead of getting to create a new elevator, you have to create multiple new elevators. Why? Because there are multiple standards for elevators depending on the country. And now you've spent time on different elevator standards instead of creating a new elevator. Creating a hidden "time sink" that I don't feel like is really talked about enough. Let's take a look at some examples of `Y` in software, their time sinks, and cover some solutions.

## Browsers

The internet, one of the most important technologies ever made, has multiple browser implementations instead of just one. Because browsers have different browser engines underneath, you have to worry about what the user's browser supports when they visit your website. And we didn't just make two, but three different engines? WebKit, ~~WebKit 2~~ Blink, and Gecko. And new engines like Ladybird are being developed. A moment of silence for the cumulative time lost as web developers had to spend their time thinking about making their website compatible with multiple browsers. But instead of trying to fix this issue, we've got companies like BrowserStack who were built on top of it.

Massive credit should be given to the [yearly Interop project](https://web.dev/blog/interop-2026) and the browser developers who have been closing the gap between the browsers. Maybe one day [caniuse](https://caniuse.com/) will be a cautionary tale we can pass on to our kids.

I propose having a single browser engine. But wouldn't a single browser engine lead to IE6: Episode II - Attack of the Chromiums? Not if that browser engine is open source. If an open source engine is changed in someway that you don't like, you can maintain patches to restore the old functionality. Like how Chromium is forked today to maintain support for Manifest V2 extensions. I'd rather take the maintenance cost of patches compared to maintaining a browser engine.

## Package Managers

Every program now gets to have its metadata and build process translated into each package format by package maintainers who then get to spend the rest of their days code reviewing and bumping version numbers. Assuming that someone else wants to take up the effort of doing that for your program. If not, you can take up the job of trying to get your program on package format that you can stomach. And nobody standardized the package names across different package repositories, so you get to figure out what each dependency is called for each one.

Imagine if developers could rely on all users having a package manager that's included with their operating system that can handle installing software. Websites could have users click on an install URL like `install://example.com/program` where the server gets your OS and architecture then sends back an archive and a checksum. The package manager steps in, validates the checksum, and then extracts the files. Dependencies could be references to other URLs or bundling them. Which is already done on mobile and contained package formats like Flatpak. And with that, we could finally put `curl | bash` behind us.

I do understand that package repositories are useful in other ways but they also introduce a whole new set of issues. Developers dealing with more tickets from users who are on an older version of the software because the package maintainer hasn't updated the package. Or problems that only happen on "unofficial" packages.

We could move the security review from package repositories to the package manager. The package manager checking a checksum against a list of safe checksums published by reviewers. And we could even do better than existing package repositories by allowing for multiple lists. Ultimately, putting control back into the user's hands about what software they trust to install. Having total control over what runs on my machine doesn't really matter if I can't easily install what I want to run.

## Programming Languages

Every new programming language (besides needing its own parser, LSP, etc.) also needs libraries. How is this new programming language going to allow me to: draw things to the screen, send/receive HTTP requests, interact with *every* operating system, interact with *every* database, create/parse *every* file format, etc. Even if you think it's unfair to say "every" for all these things, because nobody needs to read a PowerPoint presentation file in your new programming language, there's still a huge amount of these libraries that exist even if you include the popular ones. The recent boom in programming languages has further amplified this problem.

WebAssembly offers a potential solution to this problem through its component model that allows a WASM binary to export functions. Creating universal libraries that could be imported into any programming language. And an honorable mention to [Kaitai Struct](https://kaitai.io/) which handles reading (and some writing) file formats across programming languages.

## Web Frameworks

Web developers aren't immune to this either. Every component is just some state and then stuff gets updated based on that state. Not so fast, if you want a component you can't just use any random component. No, you need react-datepicker because you're building a react app. Locking you into an ecosystem for your framework.

And how these components are styled introduces another layer of fragmentation which makes everything more difficult. Meaning you may find a component you want to use, but it's not using Material Design so you can't use it. Or vice versa, it's styled properly but missing the feature that you need. And if you try to use a library with multiple components, hopefully you realize if it's missing that component/feature before you've already adopted it into your codebase.

[Svelte](https://svelte.dev/) and [Solid](https://www.solidjs.com/) deserve a special mention here for allowing you to use DOM-based libraries, meaning that they don't suffer from this issue. And component libraries like [Zag](https://zagjs.com/) that are making framework-agnostic components.

## Artificial Intelligence

Addressing the AI in the room, it doesn't really excuse anything mentioned in this article. Sure, it makes it less of a problem because now you can just have an AI generate to fill in the gaps. But you're now taking on the maintenance and security of whatever the AI created. And you aren't just ignoring those things, right?

## Conclusion

While innovation is incredibly valuable, I do believe that people should think more about the potential time sink lurking behind creating yet another `X` instead of contributing to an existing implementation. And hopefully this article could inspire you to think about solutions for how we can mitigate these time sinks. Next time you're about to create a new `X`, ask yourself: could I fork and contribute instead? Could I use or extend an existing standard? The few hours spent coordinating might save people from the unheard drain from time sinks.

And I didn't even get to cover the time sink from the other end. Like all the time spent implementing a feature into a browser engine, when another engine has already done that work.