const puppeteer = require('puppeteer');
const createCsvWriter = require('csv-writer').createObjectCsvWriter;
const fs = require('fs');
const path = require('path');
const axios = require('axios');

// CSV Writer setup to append data
const csvWriter = createCsvWriter({
    path: 'service_workers.csv',
    header: [
        { id: 'rank', title: 'rank' },
        { id: 'without_www', title: 'without_www' },
        { id: 'url', title: 'url' },
        { id: 'resolvedUrl', title: 'resolved_url' },
        { id: 'serviceWorker', title: 'service_worker' }
    ],
    append: true  // Enable appending to the file
});

// Ensure the folder for service worker scripts exists
const scriptFolderPath = path.join(__dirname, 'sw_scripts');
if (!fs.existsSync(scriptFolderPath)) {
    fs.mkdirSync(scriptFolderPath);
}



// Function to check if the CSV file is empty or doesn't exist
function checkIfFileIsEmpty(filePath) {
    return new Promise((resolve, reject) => {
        fs.stat(filePath, (err, stats) => {
            if (err) {
                if (err.code === 'ENOENT') {
                    resolve(true); // File doesn't exist
                } else {
                    reject(err); // Other file system errors
                }
            } else {
                resolve(stats.size === 0); // Check if the file is empty
            }
        });
    });
}

// Function to write headers to CSV if the file is empty or doesn't exist
async function writeHeadersIfNeeded() {
    const filePath = 'service_workers.csv';

    const isFileEmpty = await checkIfFileIsEmpty(filePath);
    if (isFileEmpty) {
        await csvWriter.writeRecords([{
            rank: 'rank',
            without_www: 'without_www',
            url: 'url',
            resolvedUrl: 'resolved_url',
            serviceWorker: 'service_worker'
        }]);
        console.log('Headers written to the CSV file.');
    }
}

// Call this function before writing any records
writeHeadersIfNeeded().catch(console.error);


async function downloadServiceWorkerScript(url, serviceWorkerUrl) {
    try {
        const fileName = url
            .replace(/^https?:\/\//, '') // Remove protocol (http:// or https://)
            .replace(/^www\./, '') 
            .replace(/[\/:]/g, '_'); // Replace slashes and colons with underscores for a valid filename


        const filePath = path.join('sw_scripts', fileName); // Define folder and file path

        // Ensure the directory exists
        fs.mkdirSync(path.dirname(filePath), { recursive: true });
        // console.log(filePath);

        // Download the service worker script
        const response = await axios.get(serviceWorkerUrl);

        // Save it to a file
        fs.writeFileSync(filePath, response.data);
        console.log(`${url}:Service worker script saved: ${filePath}`);
    } catch (error) {
        console.error(`${url}:Error downloading service worker script from ${serviceWorkerUrl}:`, error.message);
    }
}

// Function to check for service workers
async function checkServiceWorker(url, rank) {
    const browser = await puppeteer.launch({args: ['--no-sandbox'], headless:true, timeout:0});
    const page = await browser.newPage();

    const resolvedUrlWithoutWWW = url.replace(/^https?:\/\/(www\.)?/, '');



    try {
        // Navigate to the URL
        await page.goto(url, { waitUntil: 'networkidle2' });

        // Get the resolved URL after navigation
        const resolvedUrl = page.url();  // Get the final URL after redirects

        await page.reload({ waitUntil: 'networkidle2' });  // This will wait for the page to finish loading after the reload


        // Evaluate to check for service workers
        const serviceWorkers = await page.evaluate(async () => {
            if ('serviceWorker' in navigator) {
                const registrations = await navigator.serviceWorker.getRegistrations();
                if (registrations.length > 0) {
                    return registrations.map(reg => ({
                        scriptURL: reg.active ? reg.active.scriptURL : 'Not active',
                        state: reg.installing ? 'Installing' : (reg.waiting ? 'Waiting' : 'Active')
                    }));
                } else {
                    return 'No service workers found.';
                }
            } else {
                return 'Service workers not supported';
            }
        });

        // Process the result
        let serviceWorkerUrl = '';
        if (Array.isArray(serviceWorkers) && serviceWorkers.length > 0) {
            serviceWorkerUrl = serviceWorkers[0].scriptURL; // Get the first service worker URL
            // Download and save the service worker script
            await downloadServiceWorkerScript(url, serviceWorkerUrl);
        } else {
            serviceWorkerUrl = 'no'; // If no service workers are found, use the message directly
        }

        // Append to CSV immediately
        await csvWriter.writeRecords([{
            rank: rank,
            without_www: resolvedUrlWithoutWWW,
            url: url,
            resolvedUrl: resolvedUrl,
            serviceWorker: serviceWorkerUrl
        }]);

        // Output the rank and URL after processing
        console.log(`${rank}, ${url}, ${resolvedUrl}, ${serviceWorkerUrl}`);

    } catch (error) {
        console.log(`${rank}, ${url}, not_resolved, none`);
        //console.error(`Error processing ${url}:`, error.message);
        
        // Log an entry in CSV for the failed URL
        await csvWriter.writeRecords([{
            rank: rank,
            without_www: resolvedUrlWithoutWWW,
            url: url,
            resolvedUrl: 'not_resolved',
            serviceWorker: 'none' // Log the error message
        }]);

        // Output the rank and URL with error message
        //console.log(`Processed: Rank ${rank}, URL: ${url}, Error: ${error.message}`);
    } finally {
        await browser.close();
    }
}

// Function to handle command-line arguments and process URLs
async function main() {
    // Get command-line arguments passed from Python
    const args = process.argv.slice(2);

    // Ensure correct number of arguments (should be rank and URL)
    if (args.length !== 2) {
        console.error('Invalid arguments. Expected rank and URL.');
        return;
    }

    const rank = args[0];
    const url = args[1];

    await checkServiceWorker(url, rank);
}

main().catch(console.error);
