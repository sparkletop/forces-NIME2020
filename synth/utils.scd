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
