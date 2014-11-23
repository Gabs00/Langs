var fs = require('fs');

//Read in template file
var contents = fs.readFileSync('template.json', 'utf-8');

//Convert to json
var template = JSON.parse(contents);

var lang = process.argv[2];

if(lang === undefined || lang === null){
  throw new Error('Must include a language name on cmd line');
}

var langDirs = template.langDir;

//Makes the directory that holds each languange if it
//has not been created
if(!fs.existsSync(langDirs)){
  fs.mkdirSync(langDirs);
}

var langPath = langDirs + lang;

var exists = fs.existsSync(langPath);

//May change how this part works
if(exists){
  console.log(langPath, 'exists, but continuing');
} else {
  fs.mkdir(langPath);
}

var mdDir = template.mdDir;

fs.writeFileSync(
  langPath + '/Readme.md',
  fs.readFileSync(mdDir + 'Readme.md')
);

var subdirs = template.directories;

//We can go async from here
subdirs.forEach(function(dir){
  var path = langPath +"/"+ dir;
  fs.exists(path, function(exists){
    if(!exists){
      fs.mkdirSync(path);
    }

    var src = mdDir + dir + '.md';
    var dest = path +'/Readme.md';
    copy(src, dest);
  });
});

//Asynchrous file copying
function copy(src, dest){
  if(!fs.existsSync(dest)){
    fs.readFile(src, function(err, data){
      if(err){
        console.log(err);
        return;
      }
      fs.writeFile(dest, data, function(err){
        if(err){
          console.log('Error writing to', dest);
        } else {
          console.log('Created ', dest);
        }
      });
    });
  }
}
