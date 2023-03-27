const errorController = require('../controllers/errorController');
const userController = require('../controllers/userController');
const router = express.Router();

router.post('/login', userController.loginUser);
router.post('/join', userController.joinUser);
router.use(errorController.handleServerError);

module.exports = router;
