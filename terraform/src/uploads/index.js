const { S3Client, PutObjectCommand } = require('@aws-sdk/client-s3');
const busboy = require('busboy');
const { v4: uuidv4 } = require('uuid');

const s3 = new S3Client();

exports.handler = async (event) => {
    return new Promise((resolve, reject) => {
        const bb = busboy({ headers: { 'content-type': event.headers['content-type'] || event.headers['Content-Type'] } });
        let fileBuffer = [];
        let fileName = '';

        bb.on('file', (name, file, info) => {
            fileName = info.filename;
            file.on('data', (data) => fileBuffer.push(data));
        });

        bb.on('close', async () => {
            try {
                const finalBuffer = Buffer.concat(fileBuffer);
                const ext = fileName.split('.').pop();
                const key = `${process.env.UPLOAD_PREFIX}${uuidv4()}.${ext}`;

                await s3.send(new PutObjectCommand({
                    Bucket: process.env.S3_BUCKET,
                    Key: key,
                    Body: finalBuffer,
                    ContentType: `image/${ext}`
                }));

                resolve({ statusCode: 200, body: JSON.stringify({ message: "Imagen subida", key: key }) });
            } catch (err) {
                resolve({ statusCode: 500, body: JSON.stringify({ error: err.message }) });
            }
        });

        bb.write(Buffer.from(event.body, event.isBase64Encoded ? 'base64' : 'utf8'));
        bb.end();
    });
};