const {
  ChatInputCommandInteraction,
  SlashCommandBuilder,
} = require("discord.js");

module.exports = {
  data: new SlashCommandBuilder()
    .setName("chessinfo")
    .setDescription("get chess info")
    .addStringOption((option) =>
      option
        .setName("username")
        .setDescription("Enter your chess.com username")
        .setRequired(true)
    ),
  /**
   *
   * @param {ChatInputCommandInteraction} interaction
   */
  async execute(interaction) {
    const chess_username = interaction.options.getString("username");
    let chess_url = `https://api.chess.com/pub/player/${chess_username}/stats`;

    const chess_info = await fetch(chess_url)
      .then((resp) => resp.json())
      .then((resp) => {
        return resp;
      });

    const chess_bullet_last = chess_info.chess_bullet.last.rating;

    const chess_rapid_last = chess_info.chess_rapid.last.rating;

    const chess_blitz_last = chess_info.hess_blitz.last.rating;

    interaction.reply({ content: "Pong!", ephemeral: true });
  },
};
