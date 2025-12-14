{
  pkgs,
  nix-minecraft,
  ...
}: {
  services.minecraft-servers = {
    enable = true;
    eula = true;
    openFirewall = true;
    servers = {
      communityMCserver = {
        enable = true;
        package = nix-minecraft.legacyPackages.${pkgs.system}.fabricServers.fabric-1_20_1;

        jvmOpts = [
          "-Xmx12G"
          "-Xms12G"
        ];

        serverProperties = {
          server-port = 25565;
          gamemode = 0;
          spawn-chunk-radius = 0;
          difficulty = 2;
          white-list = true;
          level-seed = "Funny haha seed132";
          max-players = 10;
          spawn-protection = 0;
          view-distance = 10;
        };

        whitelist = {
          hexolexo = "080aa9de-bcf6-4f3d-8e5d-a86f4977885a";
          ToshiiChu = "fd2b9565-56a6-45f4-a062-408633d9efc5";
          I_Am_Jam = "e84a7fab-0861-464d-81e3-ed8bda07795f";
          Circle_Yuh = "786069e6-8d7e-466a-9363-45a6734e6aff";
          Beco100 = "fea5630f-000f-4020-92ec-a15227730706";
          sticklegs900 = "ef354591-75cf-4a83-acd8-da5f2b36b8ac";
          Goodgamer1900 = "7236b3a1-8994-4908-a4f9-c75a5fb2fcf2";
          TemprMC = "8bc13718-746b-4bb3-b27e-2105ca34d8db";
        };

        symlinks = {
          "mods" = pkgs.linkFarmFromDrvs "mods" (builtins.attrValues {
            fabric-api = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/P7dR8mSH/versions/UapVHwiP/fabric-api-0.92.6%2B1.20.1.jar";
              sha256 = "1syyfxwybcsa0kyfwsfhikcp13j5qm2mkdq4mc8j2sd3dm3m1khf";
            };
            fabric-kotlin = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/Ha28R6CL/versions/LcgnDDmT/fabric-language-kotlin-1.13.7%2Bkotlin.2.2.21.jar";
              sha256 = "1wmqnhcwh9b7knsg69iljxdy8wd88ryy6x7iwizd7mymxmiik5bp";
            };
            cloth-config-api = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/9s6osm5g/versions/2xQdCMyG/cloth-config-11.1.136-fabric.jar";
              sha256 = "1yj9bji8sd290xd2h9jf0mqxbw2r01yipcks2r719wy8771ljkw4";
            };

            lithium-fabric = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/gvQqBUqZ/versions/iEcXOkz4/lithium-fabric-mc1.20.1-0.11.4.jar";
              sha256 = "10p75n8ci8lxjzafrqc04l71gsvxa4k9wbanfp7hgadfjbz3w4vn";
            };
            FerriteCore = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/uXXizFIs/versions/unerR5MN/ferritecore-6.0.1-fabric.jar";
              sha256 = "096gpswpj4l5icwm2ppyrb1kwgks07hznsf3s40ajbavl0c13fn7";
            };
            Krypton = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/fQEb0iXm/versions/jiDwS0W1/krypton-0.2.3.jar";
              sha256 = "163n0l4n5hzaap39cv63h43jazjf0h7n90xhn60j3qbc4081ibb9";
            };
            Veinminer = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/Xiv4r347/versions/nDJbf1ba/oreharvester-1.20.1-1.5.jar";
              sha256 = "048x1myxx4nhqfbxaaj7w19wmvmp80cfbvsh0giaa6fw4bc8iwrv";
            };

            Treeharvester = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/abooMhox/versions/EQYmDYvI/treeharvester-1.20.1-9.1.jar";
              sha256 = "11ni47mcz57bl0hp7h77mcv9cqnn4skhwffksc59fhas0py2yqwp";
            };
            Collective = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/e0M1UDsY/versions/9fUQXa48/collective-1.20.1-8.13.jar";
              sha256 = "1llw8s1d1spavf1vi10pgnndxx0c3vhsq4p90j4pcc65fm5pbpc0";
            };

            Silk = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/aTaCgKLW/versions/3H0nUJhq/silk-all-1.10.1.jar";
              sha256 = "0f23z68c412nmvx1y1fimx3471h64mwzllq7q8d0bnrmc7vad2il";
            };

            Farmers-Delight-Refabricated = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/7vxePowz/versions/Z8UNayLO/FarmersDelight-1.20.1-2.4.1%2Brefabricated.jar";
              sha256 = "1b4ghbq38yi3c68yh23rqgpjf8dchradwcj9pvzhn8lfnl88xmw1";
            };

            Distant-Friends = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/CDaJ8xGu/versions/ElfqWcKI/DistantFriends-fabric-1.20.1-0.5.5.jar";
              sha256 = "1163sgzf77wcl6cjmq7dnj8fqns2p8l21ysp5bv96hn4gf0a0877";
            };

            Create-Fabric = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/Xbc0uyRg/versions/HAqwA6X1/create-fabric-6.0.8.1%2Bbuild.1744-mc1.20.1.jar";
              sha256 = "0nhh817zyk4sawhzx2g4j5xk8jjc6yvsvl9q85d7r5ldn0zn04x6";
            };

            Steam-n-Rails = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/ZzjhlDgM/versions/yMgmXIuq/Steam_Rails-1.6.14-beta%2Bfabric-mc1.20.1.jar";
              sha256 = "014m7lrh5zlnss8ldfhqvyb9b7816nhfyszjb8wb6pcm5r07j7h7";
            };

            #Create-Crafts-n-Additions = pkgs.fetchurl {
            #url = "https://cdn.modrinth.com/data/kU1G12Nn/versions/Y3djqUGn/createaddition-fabric%2B1.20.1-1.3.3.jar";
            #sha256 = "1iixh9lcg422z9dsm80235xahr408m8x07nix39sqcndhk56za5c";
            #};

            #Copycats = pkgs.fetchurl {
            #url = "https://cdn.modrinth.com/data/UT2M39wf/versions/WYmjbo0H/copycats-2.2.2%2Bmc.1.20.1-fabric.jar";
            #sha256 = "01wl0dp6zbgssk07rym4byd1s9bbyb09gic8s97bmgw37mppqs9y";
            #};

            #Create-Slice-n-Dice = pkgs.fetchurl {
            #url = "https://cdn.modrinth.com/data/GmjmRQ0A/versions/EzpVcwYV/sliceanddice-fabric-3.3.1.jar";
            #sha256 = "08f53yvwd62w1y4ybqjxm8cr1mpnk4x2xzwnaxnyig0d6jcgca5r";
            #};
            #Create-Deco = pkgs.fetchurl {
            #url = "https://cdn.modrinth.com/data/sMvUb4Rb/versions/GsxgfeNu/createdeco-2.0.2-1.20.1-fabric.jar";
            #sha256 = "1wq1777bc62d4pgpip7sllbcwc5rln6d0ssbsbyl7nxzakjrrysr";
            #};

            #Create-Big-Cannons = pkgs.fetchurl {
            #url = "https://cdn.modrinth.com/data/GWp4jCJj/versions/LTezmxKD/createbigcannons-5.10.0%2Bmc.1.20.1-fabric.jar";
            #sha256 = "052v6fb7zizas16c1p770n4ig417yf47vzijq0ncn82b9yf1b02p";
            #};
            Create-Structures = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/IAnP4np7/versions/nqsTHZwx/create-structures-0.1.1-1.20.1-FABRIC.jar";
              sha256 = "1xmlkp5wqa2kgfspg37niffd5i6hw9vv5nmgnkm1bq9j0aha6rri";
            };
            #Create-Interactive = pkgs.fetchurl {
            #url = "https://cdn.modrinth.com/data/MyfCcqiE/versions/66F5LBos/create_interactive-1.1.1-beta.4_1.20.1-fabric.jar";
            #sha256 = "0sq0gl886m3sjzvwbamqay92qgnfni1kk8hq8wv58kcq5dfbmib5";
            #};

            Create-Numismatics = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/Jdbbtt0i/versions/SJpLT0Bq/CreateNumismatics-1.0.15%2Bfabric-mc1.20.1.jar";
              sha256 = "1j92cmfggnixmh6wgjswz7fw0811lhjippzf8r851i6vlx4grxmk";
            };

            #Create-Aquatic-Ambitions = pkgs.fetchurl {
            #url = "https://cdn.modrinth.com/data/9SyaPzp7/versions/RFho1G3m/create_aquatic_ambitions-fabric-1.1.2%2B1.20.1.jar";
            #sha256 = "1gjvbnl8gycckfjwbsch50ihyvpv3xvfnis5p3qsi6cz6000ixxs";
            #};
            AdventureZ = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/defK2XM3/versions/mBYmRou0/adventurez-1.4.20.jar";
              sha256 = "06n1x1l639j8dcy88waq2zlk1xwsi1wq3lgmbrh1dpfnv6rkqrjr";
            };

            EldritchMobs = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/emXFPmJd/versions/1UqTBkHo/eldritch-mobs-1.15.2.jar";
              sha256 = "0lczkr74mm4la3dwm65iz1gmd9arm814b6xf2b55hi8syffa61b2";
            };

            Epic-Knight = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/L6jvzao4/versions/dRyyKuze/epic-knights-1.20.1-fabric-9.31.jar";
              sha256 = "1ab270rf6ldvpn266dnkcm12m5frdw3f54llm0gia1sbyskd4jb2";
            };

            Architectury = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/lhGA9TYQ/versions/WbL7MStR/architectury-9.2.14-fabric.jar";
              sha256 = "088kknxfh5whhpshb8a22jjkcww59jj4da4id5ngjbyvpqr70ymx";
            };

            BetterCombat = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/5sy6g3kz/versions/OtwNg4r4/bettercombat-fabric-1.9.0%2B1.20.1.jar";
              sha256 = "01zc25m8wz3dxjzyl608bc7kc1mxb16h43fgf3v3pbyk0gfq1dn1";
            };

            PlayerAnimator = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/gedNE4y2/versions/yDqYTUaf/player-animation-lib-fabric-1.0.2-rc1%2B1.20.jar";
              sha256 = "0620g00sr4rb5sqz33rzphkpmjxi4rvp8xq726c7769qlqgh440b";
            };
            #battlemages_0_0_6_1_20_1_jar = pkgs.fetchurl {
            #url = "https://cdn.modrinth.com/data/7RTcs7yj/versions/6JdlzSdX/battlemages-0.0.6-1.20.1.jar";
            #sha256 = "13q8vw0mldz39l3djlg3fcd485bs39m4ky2jwd9v7wnmw4hc56h0";
            #};

            #bards_0_1_1_1_20_1_jar = pkgs.fetchurl {
            #url = "https://cdn.modrinth.com/data/v6TwRuh6/versions/SzZBWJaj/bards-0.1.1-1.20.1.jar";
            #sha256 = "1mcs0ggfdqff5s9hkiz87nc9n0bs89sa6rsrm229bz4fpaxa0n86";
            #};

            #druid_0_0_8_1_20_1_jar = pkgs.fetchurl {
            #url = "https://cdn.modrinth.com/data/o88ZjSh6/versions/pgOnX0nO/druid-0.0.8-1.20.1.jar";
            #sha256 = "00lzjn2j547gicq25jws7kmnr58ncs5kswn2xdh3i1fmkglcl0bs";
            #};

            #ranged_weapon_api_1_1_4_1_20_1_jar = pkgs.fetchurl {
            #url = "https://cdn.modrinth.com/data/AqaIIO6D/versions/6LUH2hok/ranged_weapon_api-1.1.4%2B1.20.1.jar";
            #sha256 = "0jlhdi6iaczm1f7dzykd5fzpfcb4v0z6qg4bm0csfg6ak8vzi85g";
            #};

            #dragonscale_0_0_1_1_20_1_jar = pkgs.fetchurl {
            #url = "https://cdn.modrinth.com/data/6I7NK0fd/versions/e2lvSYB7/dragonscale-0.0.1-1.20.1.jar";
            #sha256 = "11y2i79rkfb58bmqzj36rsm6ij7al33f6s7zkwsa0qsy6bpg4bjq";
            #};

            #elemental_metals_0_0_3_1_20_1_jar = pkgs.fetchurl {
            #url = "https://cdn.modrinth.com/data/mqF8xISJ/versions/9AIfO4V1/elemental_metals-0.0.3-1.20.1.jar";
            #sha256 = "0aayhdqidflvrz9hb2iy8dv7mxrx5yqc6xav04rd8bahvzbn8k5a";
            #};

            #dragonsteel_0_0_2_1_20_1_jar = pkgs.fetchurl {
            #url = "https://cdn.modrinth.com/data/peuf5ER3/versions/Ho0RAjai/dragonsteel-0.0.2-1.20.1.jar";
            #sha256 = "1s8zky257z8jl256dx87kg2zg97yk7p4k1skpk1ff3iiddar225g";
            #};

            #spell_power_0_12_0_1_20_1_jar = pkgs.fetchurl {
            #url = "https://cdn.modrinth.com/data/8ooWzSQP/versions/G74msHHs/spell_power-0.12.0%2B1.20.1.jar";
            #sha256 = "0ql6igdjcx58v4dgnbys4j5jbshjpwc4m9mhyxs911pjbfp0hq49";
            #};

            #spell_engine_0_15_12_1_20_1_jar = pkgs.fetchurl {
            #url = "https://cdn.modrinth.com/data/XvoWJaA2/versions/Fh2MJAAe/spell_engine-0.15.12%2B1.20.1.jar";
            #sha256 = "1whj22d7drm41nb7h89ijrzlzv8fiiqpylnq0x9ksmhsjqispc5b";
            #};

            #runes_0_9_13_1_20_1_jar = pkgs.fetchurl {
            #url = "https://cdn.modrinth.com/data/lP9Yrr1E/versions/Z915LCkR/runes-0.9.13%2B1.20.1.jar";
            #sha256 = "0fj963g2i0i9p92dmrpkffk8myq1qm3w2p07c4qwy490g1ymywgw";
            #};

            #azurelibarmor_fabric_1_20_1_2_0_14_jar = pkgs.fetchurl {
            #url = "https://cdn.modrinth.com/data/pduQXSbl/versions/tSxCdYXC/azurelibarmor-fabric-1.20.1-2.0.14.jar";
            #sha256 = "0nv80ahdngxqrzndifpk7k6y26p5z8vl4s83nvc8ipgbbxxsd4wm";
            #};
            #morerunes = pkgs.fetchurl {
            #url = "https://cdn.modrinth.com/data/LWXVAgkl/versions/d892Ks5Z/morerunesmod-0.0.1-1.20.1.jar";
            #sha256 = "03vp5sgv9k3kjzk2rncy1jh4dx8wcd2laxfhl98qmfg7dhxnpryr";
            #};
            #more_spell_attributes_0_0_5_1_20_1_jar = pkgs.fetchurl {
            #url = "https://cdn.modrinth.com/data/z7YR5Db9/versions/o6lSLz3i/more_spell_attributes-0.0.5-1.20.1.jar";
            #sha256 = "0gaikjlzichcb2bx3nd17nafpblappvfrmzyjxxgwj1zh66dzv2n";
            #};
            #valkyrien_skies = pkgs.fetchurl {
            #url = "https://cdn.modrinth.com/data/V5ujR2yw/versions/Vr6LaNc4/valkyrienskies-120-2.3.0-beta.12.jar";
            #sha256 = "180yam4ifylcwn2jqpb908mcffac1k5jpbxf9yh3k84wq5dyiq96";
            #};
            #eureka_1201_1_5_2_beta_4_jar = pkgs.fetchurl {
            #url = "https://cdn.modrinth.com/data/EO8aSHxh/versions/1bAWyx2t/eureka-1201-1.5.2-beta.4.jar";
            #sha256 = "1fkvds5as0ysn18la85xh3wb45ql1nyfwmr3zf80mgab44a93pl1";
            #};
          });
          "ops.json" = pkgs.writeText "ops.json" (builtins.toJSON [
            {
              uuid = "080aa9de-bcf6-4f3d-8e5d-a86f4977885a";
              name = "hexolexo";
              level = 4;
              bypassesPlayerLimit = false;
            }
          ]);
        };
      };
    };
  };
  networking.firewall.allowedTCPPorts = [25565];
}
