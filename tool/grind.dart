import 'package:grinder/grinder.dart';

main(args) => grind(args);

@Task()
test() => new TestRunner().testAsync();

@Task()
buildApk() async {
  await runAsync(
    'flutter',
    arguments: [
      'build',
      'apk',
      '--target-platform=android-arm64',
    ],
  );
}

@Task('build ios')
buildIos() async {
  await runAsync(
    'flutter',
    arguments: [
      'build',
      'ios',
    ],
  );
}

@Task()
clean() => defaultClean();

@Task()
void sort() {
  Pub.run('import_sorter:main');
}

@Task()
void format() {
  DartFmt.format(libDir);
}

@Task('auto sort and format code')
@Depends(sort, format)
void git() {
  log(' commit to git');
  run(
    'git',
    arguments: [
      'commit',
      '-a',
      '-m',
      '[auto task] sort & format',
    ],
  );
}
