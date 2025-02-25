import subprocess
import concurrent.futures
import multiprocessing

def process_website(rank, formatted_url):
    """
    Function to process a single website (invoke the Puppeteer script).
    """
    # Call Puppeteer script with rank and formatted URL
    subprocess.run(['node', 'puppeteer.js', rank, formatted_url])


def check_service_worker_from_file(file_path):
    """
    Reads URLs from a file and processes them concurrently using multiprocessing.
    """
    # Read URLs from the file
    with open(file_path, 'r') as file:
        lines = file.readlines()

    # Get the total number of CPU cores and set max workers to one less
    num_cores = multiprocessing.cpu_count()
    max_workers = max(1, num_cores - 1)  # Ensures at least 1 worker if there's only 1 core

    # Initialize an executor for multiprocessing with the specified number of workers
    with concurrent.futures.ProcessPoolExecutor(max_workers=max_workers) as executor:
        futures = []  # This will store the futures of each submitted task
        full_list = []
        
        for line in lines:
            # Split the line into rank and URL
            rank, raw_url = line.strip().split(',')
            formatted_url = f"http://www.{raw_url.strip()}"

            # Submit the task for concurrent execution
            future = executor.submit(process_website, rank, formatted_url)
            futures.append(future)
            
            # Add the processed URL to the full list
            full_list.append((rank, formatted_url))
        
        # Wait for all futures to complete
        concurrent.futures.wait(futures)


# Example usage: Provide the file path for urls.txt
file_path = 'tranco_2024.txt'
check_service_worker_from_file(file_path)
