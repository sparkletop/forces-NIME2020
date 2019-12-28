~loadSubDir = { | subDir |
	(PathName.new(thisProcess.nowExecutingPath).pathOnly +/+ PathName.new(subDir.asString))
	.filesDo{ | file |
		(file.extension=="scd").if(
			{
				("Loading" + file.fileName).postln;
				file.fullPath.load;
			},
			{
				("Skipping" + file + "- not a .scd file").warn;
			}
		)
	};
};

~loadBufDir = {
	arg subDir, fileTypes = ["wav", "aiff", "ogg"];
	var bufferArr, subDirPath;
	subDirPath = PathName.new(thisProcess.nowExecutingPath).pathOnly;
	subDirPath = subDirPath +/+ PathName.new(subDir.asString);
	bufferArr = subDirPath
	.files
	.select({ |file|
		fileTypes.includesEqual(file.extension);
	})
	.collect({ |file|
		Buffer.read(s, file.fullPath, action: {
			("Loaded" + file.fileName).postln;
		});
	});
};