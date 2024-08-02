import xml.etree.ElementTree as ET
import base64
import sys

def process_xml(input_file, updated_script_file, payload_file):
    # Parse the input XML file
    tree = ET.parse(input_file)
    root = tree.getroot()

    # Remove script_contents and script_contents_encoded if they exist
    for elem in root.findall('script_contents'):
        root.remove(elem)
    for elem in root.findall('script_contents_encoded'):
        root.remove(elem)

    # Read the updated script_contents
    with open(updated_script_file, 'r') as f:
        script_contents = f.read()

    # Add the updated script_contents to the XML
    script_elem = ET.SubElement(root, 'script_contents')
    script_elem.text = script_contents

    # Encode script_contents to script_contents_encoded
    script_contents_encoded = base64.b64encode(script_contents.encode()).decode()
    encoded_elem = ET.SubElement(root, 'script_contents_encoded')
    encoded_elem.text = script_contents_encoded

    # Write the updated XML to the payload file
    # Ensure XML declaration is included with UTF-8 encoding
    tree.write(payload_file, encoding='utf-8', xml_declaration=True)

if __name__ == "__main__":
    input_file = sys.argv[1]
    updated_script_file = sys.argv[2]
    payload_file = sys.argv[3]
    process_xml(input_file, updated_script_file, payload_file)
