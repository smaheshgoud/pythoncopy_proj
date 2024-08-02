import xml.etree.ElementTree as ET
import base64
import sys

def process_xml(input_file, updated_script_file, payload_file):
    # Parse the input XML file
    tree = ET.parse(input_file)
    root = tree.getroot()

    # Extract the existing script_contents from the input XML
    script_contents_elem = root.find('script_contents')
    if script_contents_elem is None:
        raise ValueError("No <script_contents> found in the input XML file.")

    script_contents = script_contents_elem.text

    # Check if an updated script file is provided
    if updated_script_file:
        # If an updated script file is provided, read from it
        with open(updated_script_file, 'r') as f:
            script_contents = f.read()

    # Encode script_contents to script_contents_encoded
    script_contents_encoded = base64.b64encode(script_contents.encode()).decode()

    # Remove existing script_contents and script_contents_encoded elements
    for elem in root.findall('script_contents'):
        root.remove(elem)
    for elem in root.findall('script_contents_encoded'):
        root.remove(elem)

    # Add the original script_contents back to the XML
    script_elem = ET.SubElement(root, 'script_contents')
    script_elem.text = script_contents

    # Add the encoded script_contents to the XML
    encoded_elem = ET.SubElement(root, 'script_contents_encoded')
    encoded_elem.text = script_contents_encoded

    # Write the updated XML to the payload file
    tree.write(payload_file, encoding='utf-8', xml_declaration=True)

if __name__ == "__main__":
    input_file = sys.argv[1]
    updated_script_file = sys.argv[2] if len(sys.argv) > 2 else None
    payload_file = sys.argv[3]
    process_xml(input_file, updated_script_file, payload_file)
