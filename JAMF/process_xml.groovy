import groovy.xml.XmlParser
import groovy.xml.XmlUtil
import java.nio.file.Files
import java.nio.file.Paths

// Define the input XML file and output script file paths
def inputFile = 'input.xml'
def outputScriptFile = 'extracted_script.sh'
def repoPath = "https://github.com/your-repo/path/to/${outputScriptFile}"

// Parse the XML file
def xml = new XmlParser().parse(new File(inputFile))

// Extract the <script_contents> tag content
def scriptContents = xml.script_contents.text()

// Write the script contents to a new text file
Files.write(Paths.get(outputScriptFile), scriptContents.getBytes('UTF-8'))

// Replace the content of <script_contents> with the repository path of the new script file
xml.script_contents[0].value = repoPath

// Convert the modified XML back to a string
def updatedXml = XmlUtil.serialize(xml)

// Write the updated XML back to the input file
Files.write(Paths.get(inputFile), updatedXml.getBytes('UTF-8'))

println "Script contents extracted to ${outputScriptFile}"
println "Updated XML saved to ${inputFile}"
