const db = require('../config/db');
const { QueryTypes } = require('sequelize');
const createError = require('http-errors');
const multer = require('multer');
const path = require('path');
const sharp = require('sharp');

// ตั้งค่า multer สำหรับอัปโหลดไฟล์
const storage = multer.diskStorage({
  destination: (req, file, cb) => {
    cb(null, path.join(__dirname, '../../frontend/public/uploads')); // ใช้ path.join เพื่อกำหนดเส้นทางที่ถูกต้อง
  },
  filename: (req, file, cb) => {
    cb(null, Date.now() + path.extname(file.originalname));
  },
});

const upload = multer({ storage });

// ฟังก์ชันสำหรับปรับขนาดภาพและสร้าง thumbnail
const uploadImages = async (files) => {
  const imagePaths = [];

  for (let i = 0; i < files.length; i++) {
    if (files[i]) {
      if (!files[i].filename) {
        throw createError(400, `File ${i + 1} does not have a valid filename`);
      }

      const filePath = path.join('uploads', files[i].filename);
      const thumbnailPath = path.join('uploads', `thumb-${files[i].filename}`);

      // ใช้ sharp เพื่อสร้าง thumbnail
      await sharp(filePath)
        .resize(150, 150) // ปรับขนาดเป็น 150x150 px
        .toFile(thumbnailPath);

      imagePaths.push(files[i].filename);
    } else {
      imagePaths.push(null);
    }
  }

  return imagePaths;
};

// ดึงข่าวสารทั้งหมด
const getAllNews = async (req, res, next) => {
  try {
    const query = 'SELECT * FROM tb_news';
    const news = await db.query(query, { type: QueryTypes.SELECT });
    res.json(news);
  } catch (err) {
    next(err);
  }
};

// ดึงข่าวสารตาม ID
const getNewsById = async (req, res, next) => {
  const { id } = req.params;

  try {
    const query = 'SELECT * FROM tb_news WHERE id = ?';
    const result = await db.query(query, {
      replacements: [id],
      type: QueryTypes.SELECT,
    });

    if (result.length === 0) {
      throw createError(404, 'News not found');
    }

    res.json(result[0]);
  } catch (err) {
    next(err);
  }
};


const addNews = async (req, res, next) => {
  const { topic, detail, author } = req.body;
  const files = req.files || {}; 

  console.log('Raw req.files:', JSON.stringify(req.files, null, 2));

  try {
    const imageNames = ['img1', 'img2', 'img3', 'img4', 'img5'];

    const images = imageNames.map(img => ({
      path: files[img]?.[0]?.path ?? null,
      filename: files[img]?.[0]?.filename ?? null
    }));

    console.log('Extracted image filenames:', images.map(image => image.filename));

    // ป้องกัน error โดยใช้ ?? null เพื่อให้แน่ใจว่าไม่มี undefined
    const replacements = [
      topic, 
      detail, 
      author, 
      images[0].filename ?? null, 
      images[1].filename ?? null, 
      images[2].filename ?? null, 
      images[3].filename ?? null, 
      images[4].filename ?? null
    ];

    console.log('SQL replacements:', replacements);

    const query = `
      INSERT INTO tb_news (topic, detail, author, img1, img2, img3, img4, img5)
      VALUES (?, ?, ?, ?, ?, ?, ?, ?)
    `;
    const result = await db.query(query, {
      replacements,
      type: QueryTypes.INSERT,
    });

    console.log('Insert Result:', result);
    res.status(201).json({ message: 'News created successfully', id: result[0] });
  } catch (err) {
    console.error('Error adding news:', err);
    next(err);
  }
};





// อัปเดตข่าวสาร
// อัปเดตข่าวสาร
const updateNews = async (req, res, next) => {
  const { id } = req.params;
  const { topic, detail, author } = req.body;
  const files = req.files || {};

  try {
    const imageNames = ['img1', 'img2', 'img3', 'img4', 'img5'];
    const images = await Promise.all(imageNames.map(async (img, index) => {
      if (files[img]) {
        // หากมีไฟล์ที่เกี่ยวข้อง ให้ปรับขนาดภาพและรับชื่อไฟล์
        const uploadedImages = await uploadImages(files[img]);
        return uploadedImages[0]; // รับชื่อไฟล์แรกที่ถูกอัปโหลด
      }
      return null; // ไม่มีไฟล์ให้ใช้
    }));

    const query = `
      UPDATE tb_news
      SET topic = ?, detail = ?, author = ?, updated_at = NOW(),
          img1 = ?, img2 = ?, img3 = ?, img4 = ?, img5 = ?
      WHERE id = ?
    `;
    
    const result = await db.query(query, {
      replacements: [
        topic, 
        detail, 
        author, 
        images[0], 
        images[1], 
        images[2], 
        images[3], 
        images[4], 
        id
      ],
      type: QueryTypes.UPDATE,
    });

    if (result[0] === 0) {
      throw createError(404, 'News not found');
    }

    res.json({ message: 'News updated successfully' });
  } catch (err) {
    console.error('Error updating news:', err);
    next(err);
  }
};




// ลบข่าวสาร
const deleteNews = async (req, res, next) => {
  const { id } = req.params;

  try {
    const query = 'DELETE FROM tb_news WHERE id = ?';
    const result = await db.query(query, {
      replacements: [id],
      type: QueryTypes.DELETE,
    });

    // ตรวจสอบผลลัพธ์
    if (result && result.affectedRows === 0) {
      throw createError(404, 'News not found');
    }

    res.json({ message: 'News deleted successfully' });
  } catch (err) {
    next(err);
  }
};

module.exports = {
  getAllNews,
  getNewsById,
  addNews,
  updateNews,
  deleteNews,
  upload,
};