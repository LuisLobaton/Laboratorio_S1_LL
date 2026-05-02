const { S3Client, GetObjectCommand, PutObjectCommand } = require('@aws-sdk/client-s3');
const sharp = require('sharp');

const s3 = new S3Client();

exports.handler = async (event) => {
    for (const record of event.Records) {
        const body = JSON.parse(record.body);
        if (!body.Records) continue;
        
        const bucket = body.Records[0].s3.bucket.name;
        const key = decodeURIComponent(body.Records[0].s3.object.key.replace(/\+/g, ' '));

        try {
            // 1. Bajar la imagen original
            const response = await s3.send(new GetObjectCommand({ Bucket: bucket, Key: key }));
            const streamToBuffer = async (stream) => {
                const chunks = [];
                for await (const chunk of stream) chunks.push(chunk);
                return Buffer.concat(chunks);
            };
            const imageBuffer = await streamToBuffer(response.Body);

            // 2. Procesar con sharp
            const roundedCorners = Buffer.from(
                '<svg><circle cx="20" cy="20" r="20" /></svg>'
            );

            const processedImage = await sharp(imageBuffer)
                .resize(40, 40, { fit: 'cover' })
                .composite([{ input: roundedCorners, blend: 'dest-in' }])
                .png()
                .toBuffer();

            // 3. Subir a la carpeta processed/
            const newKey = key.replace('uploads/', process.env.PROCESSED_PREFIX).replace(/\.[^/.]+$/, "_circular.png");
            
            await s3.send(new PutObjectCommand({
                Bucket: process.env.S3_BUCKET,
                Key: newKey,
                Body: processedImage,
                ContentType: 'image/png'
            }));

            console.log(`Imagen procesada y guardada en: ${newKey}`);

        } catch (error) {
            console.error(`Error procesando ${key}:`, error);
            throw error; 
        }
    }
    return { statusCode: 200 };
};