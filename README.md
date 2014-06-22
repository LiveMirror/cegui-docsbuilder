# CEGUI automatic API docs builder

## Let's build the docs!

1. Make sure you have doxygen and all fonts
`bash
# as root
yum install doxygen
yum install gnu-free-sans-fonts
`
2. Call:
`bash
cd docs-builder
./builder build
`
3. Wait for it to finish
4. Collect the bits in local-temp/output

   It will contain folders with doxygen HTML as well as zip files conveniently prepared for upload to sourceforge

## Uploading to sourceforge

CEGUI hosts API reference and other docs at http://static.cegui.org.uk/docs Uploading there requires SourceForge project access to CEGUI.

1. Get the zip files into `/home/project-web/crayzedsgui/htdocs/docs/` using scp

2. Request a shell
```bash
ssh -t $username,crayzedsgui@shell.sourceforge.net create
```
3. Navigate to the crayzedsgui htdocs/docs folder
```bash
cd /home/project-web/crayzedsgui/htdocs/docs/
```
4. Extract all the zip files
```bash
for z in *.zip; do unzip $z; done
```
5. Cleanup
```bash
rm *.zip
```
   Note: We need to remove the zip files because sourceforge htdocs is not a hosting service.

## Making sure the support files are in place
To enable extra features - version switching and index - we need extra files provided in the support folder of this repo. These need to be placed in `/home/project-web/crayzedsgui/htdocs/docs/`.

**warning**: These PHP files are very nasty and I do not recommend looking at them. I think it's unlikely that they are exploitable but if I am wrong, please report it to us so we can fix it. We strongly prefer that to somebody uploading malware to our sourceforge htdocs.

# Autobuilding CEED docs
Not implemented yet!