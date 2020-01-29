# Album maker 0.1.0

Scripts to prepare the pictures of a folder for Web publiction (thumbnails and Web interface).

Written from the software created by [Douglas Lovell](https://github.com/wbreeze).

## Requirements

- Xalan
- ImageMagik

```
sudo apt install imagemagik xalan
```

## Configuration of SSH publication

1. Copy `config-publish_template.sh` as `config-publish.sh`
2. Edit `config-publish.sh`

## Usage

1. Run `album.sh` with the folder of your pictures as first parameter to generate the HTML photo album. Spaces in directoy name are OK.

Example :

```
./album.sh ~/Pictures/My\ birthday\ party/
```

A `web/` directory is created in your album directory, with the HTML content.

2. Run `publish.sh` with the same folder as first parameter

```
./publish.sh ~/Pictures/My\ birthday\ party/
```


