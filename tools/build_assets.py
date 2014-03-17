import os, glob, re

def main():
	currentDir = os.path.abspath(os.path.dirname(__file__))
	projectDir = os.path.join(currentDir, os.path.pardir)
	assetsDir = os.path.join(projectDir, "assets")
	
	embedsCode = ""
	idToDefHashCode = ""

	for (dirpath, dirnames, filenames) in os.walk(assetsDir):
		for f in filenames:
			filePath = os.path.join(dirpath, f)
			assetId = re.sub(r"\\", "/", filePath[filePath.rfind("\\assets\\") + 8:])
			embedClass = re.sub(r"\W", "_", assetId).upper()
			assetType = "bitmap" if f.endswith(".png") else ("bitmap" if f.endswith(".jpg") else ("sound" if f.endswith(".mp3") else ("xml" if f.endswith(".xml") else "binary")))
			if assetType == "xml" or assetType == "binary":
				embedsCode = embedsCode + '[Embed(source="../../../assets/{0}", mimeType="application/octet-stream")]\nprivate static const {1}:Class;\n'.format(assetId, embedClass)
			else:
				embedsCode = embedsCode + '[Embed(source="../../../assets/{0}")]\nprivate static const {1}:Class;\n'.format(assetId, embedClass)
			idToDefHashCode = idToDefHashCode + '"{0}" : {{ "class" : {1}, "type" : "{2}" }},\n'.format(assetId, embedClass, assetType)
	
	idToDefHashCode = idToDefHashCode[:idToDefHashCode.rfind("},") + 1] + "\n"
	
	assetInclude = "// Auto-generated file, do not edit\n{0}\nprivate static const idToAssetDefHash:Object = {{\n{1}}};\n".format(embedsCode, idToDefHashCode)
	
	assetIncludePath = os.path.join(projectDir, "src\\rust\\assets\\Assets_include.as")
	assetIncludeFile = open(assetIncludePath, "wb")
	assetIncludeFile.write(assetInclude.encode("utf-8"))
	assetIncludeFile.close()
	
try:
	main()
except Exception as ex:
	print("ERROR: " + str(ex))

print("Assets list created")
#input()
