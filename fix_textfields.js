const fs = require('fs');
const glob = require('glob');

const files = glob.sync('lib/features/**/*.dart');

for (const file of files) {
  let content = fs.readFileSync(file, 'utf8');
  if (content.includes('TextField(') || content.includes('TextFormField(')) {
    // Only target files with AlertDialog to be safe, or just replace everywhere
    if (content.includes('AlertDialog(')) {
      // Replace TextField( and TextFormField( with style injected
      content = content.replace(/\b(TextField|TextFormField)\s*\(/g, (match) => {
        return match + '\nstyle: const TextStyle(color: Colors.black),';
      });
      fs.writeFileSync(file, content);
      console.log('Fixed', file);
    }
  }
}
