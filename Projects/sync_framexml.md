## init classic_era
```sh
cd "D:\Repo\wow\wow-framexml"
git clone -b classic_era --single-branch https://github.com/Gethe/wow-ui-source "wow-ui-source vanilla"
cd "wow-ui-source vanilla"
git remote add ketho https://github.com/Ketho/wow-ui-source-vanilla
git pull origin classic_era
git push ketho classic_era:vanilla
```

## init mists
```sh
cd "D:\Repo\wow\wow-framexml"
git clone -b classic --single-branch https://github.com/Gethe/wow-ui-source "wow-ui-source mists"
cd "wow-ui-source mists"
git remote add ketho https://github.com/Ketho/wow-ui-source-mists
git pull origin classic
git push ketho classic:mists
```

## init midnight
```sh
cd "D:\Repo\wow\wow-framexml"
git clone -b beta --single-branch https://github.com/Gethe/wow-ui-source "wow-ui-source midnight"
cd "wow-ui-source midnight"
git remote add ketho https://github.com/Ketho/wow-ui-source-midnight
git pull origin beta
git push ketho beta:beta
```

## update
```sh
cd "D:\Repo\wow\wow-framexml\wow-ui-source vanilla"
git pull origin classic_era
git push ketho classic_era:classic_era

cd "D:\Repo\wow\wow-framexml\wow-ui-source mists"
git pull origin classic
git push ketho classic

cd "D:\Repo\wow\wow-framexml\wow-ui-source midnight"
git pull origin beta
git push ketho beta

```
