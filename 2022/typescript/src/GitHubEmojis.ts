// query for GitHub Emojis and save emojis into a file
// cerner_2tothe5th_2022

// npm install
// export GITHUB_API="REST API url"
// ts-node src/GitHubEmojis.ts

import axios from 'axios';

const { createCanvas, loadImage } = require('canvas')
const fs = require("fs");

const canvas = createCanvas(2800, 3200)
const ctx = canvas.getContext('2d')
const url = process.env.GITHUB_API

// interface representing the API response
interface Emojis { [key: string]: String }

axios.create({ baseURL: url }).get<Emojis>("emojis").then(
    ({ data }) => {
        Promise.allSettled(
            // change the slice here to fetch a smaller subset
            Object.values(data).slice(0, 1874).map(async value => await loadImage(value))
        ).then((results) => {
            const responses = results.filter((res) => res.status === 'fulfilled') as PromiseFulfilledResult<any>[];
            var foo = 0, bar = 0
            // wait for images to load and then draw them into a grid..
            responses.forEach((image) => {
                ctx.drawImage(image.value, foo, bar)
                foo += 70
                if (foo >= 2800) { foo = 0; bar += 70 }
            })
            // save the buffer into a file, example output with available in the same folder
            const buffer = canvas.toBuffer("image/png");
            fs.writeFileSync("./image.png", buffer);
        })
    })

