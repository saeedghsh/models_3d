"""A script to automatically generate an inventory of the thingiverse directory
stored as Markdown file"""

import argparse
import os


def _generate_markdown(directory: str, filepath: str):
    markdown_content = []

    # Iterate over all the 'part_name' directories directly under root
    for part_name in sorted(os.listdir(directory)):
        part_name_path = os.path.join(directory, part_name)
        images_path = os.path.join(part_name_path, "images")

        # Ensure it's a directory
        if os.path.isdir(part_name_path):
            # Get the first image
            try:
                first_image = sorted(os.listdir(images_path))[0]
            except (FileNotFoundError, IndexError):
                # Either the images directory doesn't exist or is empty
                first_image = None

            if first_image:
                image_path = os.path.join(images_path, first_image)
                markdown_content.append("\n---\n")
                markdown_content.append(f"**{part_name}**  \n")
                markdown_content.append(
                    f"[{os.path.abspath(part_name_path)}]({os.path.abspath(part_name_path)})\n\n"
                )
                markdown_content.append(f"![picture]({image_path})\n\n")

    # Write the markdown content to output.md
    with open(filepath, "w", encoding="utf-8") as f:
        f.writelines(markdown_content)


def _parse_arguments() -> argparse.Namespace:
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--directory",
        type=str,
        default="thingiverse.com",
        help="Directory to backup",
    )
    parser.add_argument(
        "--output-file-path",
        type=str,
        default="local_thingiverse.md",
        help="Directory to backup",
    )
    args = parser.parse_args()
    return args


# Example usage
if __name__ == "__main__":
    arguments = _parse_arguments()
    _generate_markdown(arguments.directory, arguments.output_file_path)
