const {
  ChatInputCommandInteraction,
  SlashCommandBuilder,
  EmbedBuilder,
} = require("discord.js");

const fetch = (...args) =>
  import("node-fetch").then(({ default: fetch }) => fetch(...args));
const { config } = require("dotenv");
config();

function formatString(string) {
  string =
    string.split("_")[0].charAt(0).toUpperCase() +
    string.split("_")[0].slice(1).toLowerCase();
  return string;
}

module.exports = {
  data: new SlashCommandBuilder()
    .setName("league-info")
    .setDescription("get league rank")
    .addStringOption((option) =>
      option
        .setName("summoner-name")
        .setDescription("enter your summoner name")
        .setRequired(true)
    ),
  /**
   *
   * @param {ChatInputCommandInteraction} interaction
   */
  async execute(interaction) {
    const API_KEY = process.env.LEAGUE_API_KEY;
    const summoner_name = interaction.options.getString("summoner-name");
    const league_url_name = `https://euw1.api.riotgames.com/lol/summoner/v4/summoners/by-name/${summoner_name}`;

    try {
      const profile = await fetch(league_url_name, {
        headers: {
          "X-Riot-Token": API_KEY,
        },
      })
        .then((resp) => resp.json())
        .then((resp) => {
          return resp;
        });

      const version = await fetch(
        "https://ddragon.leagueoflegends.com/api/versions.json"
      )
        .then((resp) => resp.json())
        .then((resp) => {
          return resp[0];
        });

      const summoner_name_encrypt = profile.id;
      const icon = profile.profileIconId;
      console.log(summoner_name_encrypt);

      const league_url_rank = `https://euw1.api.riotgames.com/lol/league/v4/entries/by-summoner/${summoner_name_encrypt}`;
      const rank_solo = await fetch(league_url_rank, {
        headers: {
          "X-Riot-Token": API_KEY,
        },
      })
        .then((resp) => resp.json())
        .then((resp) => {
          if (resp[0].queueType != "RANKED_SOLO_5x5") return resp[1];
          return resp[0];
        });
      const solo_txt =
        formatString(rank_solo.queueType.split("_")[0]) +
        " " +
        formatString(rank_solo.queueType.split("_")[1]);

      const rank_flex = await fetch(league_url_rank, {
        headers: {
          "X-Riot-Token": API_KEY,
        },
      })
        .then((resp) => resp.json())
        .then((resp) => {
          if (resp[0].queueType != "RANKED_SOLO_5x5") return resp[0];
          return resp[1];
        });

      const flex_txt =
        formatString(rank_flex.queueType.split("_")[0]) +
        " " +
        formatString(rank_flex.queueType.split("_")[1]);

      const leagueEmbed = new EmbedBuilder()
        .setColor(0x0099ff)
        .setTitle("League Rank")
        .setAuthor({
          name: summoner_name,
          iconURL: `https://ddragon.leagueoflegends.com/cdn/${version}/img/profileicon/${icon}.png`,
        })
        .setURL(`https://www.op.gg/summoners/euw/${summoner_name}`)
        .setThumbnail(
          "https://i.pinimg.com/originals/b8/3e/6f/b83e6fea403a390bd06ae17c187408e3.png"
        )
        .addFields(
          {
            name: solo_txt,
            value: `${rank_solo.tier} ${rank_solo.rank} ${rank_solo.leaguePoints} lp`,
          },
          {
            name: flex_txt,
            value: `${rank_flex.tier} ${rank_flex.rank} ${rank_flex.leaguePoints} lp`,
          }
        );

      console.log(solo_txt);

      interaction.reply({
        embeds: [leagueEmbed],
        ephemeral: false,
      });
    } catch (error) {
      console.log(error);
    }
  },
};
